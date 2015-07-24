require 'octokit'

class GithubFetcher
  ORGANISATION ||= ENV['SEAL_ORGANISATION']

  attr_accessor :people, :repos, :pull_requests

  def initialize(team_members_accounts, team_repos, use_labels, exclude_labels)
    @github = Octokit::Client.new(:access_token => ENV['GITHUB_TOKEN'])
    @github.user.login
    Octokit.auto_paginate = true
    @people = team_members_accounts
    @repos = team_repos.sort!
    @pull_requests = {}
    @old_pull_requests = []
    @use_labels = use_labels
    @exclude_labels = exclude_labels
  end

  def list_pull_requests
    @repos.each do |repo|
      response = @github.pull_requests("#{ORGANISATION}/#{repo}", state: "open")
      response.reject { |pr| hidden_labels(pr, repo) }
        .select { |pr| person_subscribed?(pr) }
        .each do |pull_request|
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

  def old_pull_requests
    @repos.each do |repo|
      response = @github.pull_requests("#{ORGANISATION}/#{repo}", state: "open")
      response.each do |pull_request|
        if person_subscribed?(pull_request)
          comments = @github.pull_request_comments("#{ORGANISATION}/#{repo}", pull_request.number) #this returns an empty array, not sure why
          comments.each do |comment|
            comment.updated_at
          end
        end
      end
    end
  end

  private

  attr_reader :use_labels, :exclude_labels

  def person_subscribed?(pull_request)
    people.empty? || people.include?("#{pull_request.user.login}")
  end

  def count_comments(pull_request, repo)
    review_comments = @github.pull_request("#{ORGANISATION}/#{repo}", pull_request.number).review_comments
    comments = @github.pull_request("#{ORGANISATION}/#{repo}", pull_request.number).comments
    @total_comments = (review_comments + comments).to_s
  end

  def labels(pull_request, repo)
    return [] unless use_labels
    @github.labels_for_issue("#{ORGANISATION}/#{repo}", pull_request.number)
  end

  def hidden_labels(pull_request, repo)
    return false unless exclude_labels
    !(exclude_labels & labels(pull_request, repo).map { |l| l['name'] }).empty?
  end
end
