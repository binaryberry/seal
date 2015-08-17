require 'octokit'

class GithubFetcher
  ORGANISATION ||= ENV['SEAL_ORGANISATION']

  attr_accessor :people, :repos

  def initialize(team_members_accounts, team_repos, use_labels, exclude_labels, exclude_titles)
    @github = Octokit::Client.new(:access_token => ENV['GITHUB_TOKEN'])
    @github.user.login
    Octokit.auto_paginate = true
    @people = team_members_accounts
    @repos = team_repos.sort!
    @pull_requests = {}
    @use_labels = use_labels
    @exclude_labels = exclude_labels
    @exclude_titles = exclude_titles.map(&:downcase).uniq if exclude_titles
    @labels = {}
  end

  def list_pull_requests
    @repos.each do |repo|
      response = @github.pull_requests("#{ORGANISATION}/#{repo}", state: "open")
      response.reject { |pr| hidden?(pr, repo) }.each do |pull_request|
        @pull_requests[pull_request.title] = {}.tap do |pr|
          pr['title'] = pull_request.title
          pr['link'] = pull_request.html_url
          pr['author'] = pull_request.user.login
          pr['repo'] = repo
          pr['comments_count'] = count_comments(pull_request, repo)
          pr['updated'] = Date.parse(pull_request.updated_at.to_s)
          pr['labels'] = labels(pull_request, repo)
        end
      end
    end
    @pull_requests
  end

  private

  attr_reader :use_labels, :exclude_labels, :exclude_titles

  def person_subscribed?(pull_request)
    people.empty? || people.include?("#{pull_request.user.login}")
  end

  def count_comments(pull_request, repo)
    pr = @github.pull_request("#{ORGANISATION}/#{repo}", pull_request.number)
    (pr.review_comments + pr.comments).to_s
  end

  def labels(pull_request, repo)
    return [] unless use_labels
    key = "#{ORGANISATION}/#{repo}/#{pull_request.number}".to_sym
    @labels[key] ||= @github.labels_for_issue("#{ORGANISATION}/#{repo}", pull_request.number)
  end

  def hidden?(pull_request, repo)
    hidden_labels(pull_request, repo) || excluded_title?(pull_request.title) || !person_subscribed?(pull_request)
  end

  def hidden_labels(pull_request, repo)
    return false unless exclude_labels
    !(exclude_labels & labels(pull_request, repo).map { |l| l['name'] }).empty?
  end

  def excluded_title?(title)
    exclude_titles && exclude_titles.any? { |t| title.downcase.include?(t) }
  end
end
