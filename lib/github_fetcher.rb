require 'octokit'

class GithubFetcher
  ORGANISATION ||= ENV['SEAL_ORGANISATION']

  attr_accessor :repos

  def initialize(team_members_accounts, github_team_names, team_repos, use_labels, exclude_labels, exclude_titles)
    @github = Octokit::Client.new(:access_token => ENV['GITHUB_TOKEN'])
    @github.user.login
    Octokit.auto_paginate = true
    @team_members_accounts = team_members_accounts
    @github_team_names = github_team_names
    @repos = team_repos.sort!
    @pull_requests = {}
    @use_labels = use_labels
    @exclude_labels = exclude_labels.map(&:downcase).uniq if exclude_labels
    @exclude_titles = exclude_titles.map(&:downcase).uniq if exclude_titles
    @labels = {}
  end

  def list_pull_requests
    @repos.each do |repo|
      begin
        response = @github.pull_requests("#{ORGANISATION}/#{repo}", state: "open")
      rescue => e
        puts "Unable to get pull requests for repo #{repo}: #{e}"
        next
      end
      response.reject { |pr| hidden?(pr, repo) }.each do |pull_request|
        @pull_requests[pull_request.title] = {}.tap do |pr|
          pr['title'] = pull_request.title
          pr['link'] = pull_request.html_url
          pr['author'] = pull_request.user.login
          pr['repo'] = repo
          pr['comments_count'] = count_comments(pull_request, repo)
          pr['thumbs_up'] = count_thumbs_up(pull_request, repo)
          pr['updated'] = Date.parse(pull_request.updated_at.to_s)
          pr['labels'] = labels(pull_request, repo)
        end
      end
    end
    @pull_requests
  end

  private

  attr_reader :use_labels, :exclude_labels, :exclude_titles, :team_members_accounts

  def person_subscribed?(pull_request)
    people.empty? || people.include?("#{pull_request.user.login}")
  end

  def people
    @people ||= team_members_accounts + github_team_members
  end

  def github_team_members
    @github_team_members ||= [].tap do |team_members|
      github_team_ids.each do |team_id|
        team_members.concat(@github.team_members(team_id).map(&:login))
      end
    end.uniq
  end

  def github_teams
    @github_teams ||= {}.tap do |teams|
      @github.organization_teams(ORGANISATION).each do |team|
        team_name = team[:name]
        team_id = team[:id]

        teams[team_name] = team_id
      end
    end
  end

  def github_team_ids
    @github_team_ids ||= begin
                           @github_team_names.map { |name| github_teams.fetch(name) }
                         rescue KeyError => e
                           puts '-' * 80
                           puts "#{e}: Known teams: #{github_teams.keys.sort}"
                           puts '-' * 80
                           raise
                         end
  end

  def count_comments(pull_request, repo)
    pr = @github.pull_request("#{ORGANISATION}/#{repo}", pull_request.number)
    (pr.review_comments + pr.comments).to_s
  end

  def count_thumbs_up(pull_request, repo)
    response = @github.issue_comments("#{ORGANISATION}/#{repo}", pull_request.number)
    comments_string = response.map {|comment| comment.body}.join
    thumbs_up = comments_string.scan(/:\+1:/).count.to_s
  end

  def labels(pull_request, repo)
    return [] unless use_labels
    key = "#{ORGANISATION}/#{repo}/#{pull_request.number}".to_sym
    @labels[key] ||= @github.labels_for_issue("#{ORGANISATION}/#{repo}", pull_request.number)
  end

  def hidden?(pull_request, repo)
    excluded_label?(pull_request, repo) || excluded_title?(pull_request.title) || !person_subscribed?(pull_request)
  end

  def excluded_label?(pull_request, repo)
    return false unless exclude_labels
    lowercase_label_names = labels(pull_request, repo).map { |l| l['name'].downcase }
    exclude_labels.any? { |e| lowercase_label_names.include?(e) }
  end

  def excluded_title?(title)
    exclude_titles && exclude_titles.any? { |t| title.downcase.include?(t) }
  end
end
