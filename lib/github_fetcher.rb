require "octokit"

class GithubFetcher
  # TODO: remove media type when review support comes out of preview
  Octokit.default_media_type = "application/vnd.github.black-cat-preview+json"

  def initialize(team)
    @organisation = ENV["SEAL_ORGANISATION"]
    @github = Octokit::Client.new(access_token: ENV["GITHUB_TOKEN"])
    @github.api_endpoint = ENV["GITHUB_API_ENDPOINT"] if ENV["GITHUB_API_ENDPOINT"]
    @github.auto_paginate = true
    @people = team.members
    @use_labels = team.use_labels
    @exclude_labels = team.exclude_labels.map(&:downcase).uniq
    @exclude_titles = team.exclude_titles.map(&:downcase).uniq
    @labels = {}
    @exclude_repos = team.exclude_repos
    @include_repos = team.include_repos
  end

  def list_pull_requests
    github.user.login

    pull_requests_from_github
      .reject { |pr| hidden?(pr) }
      .map { |pr| present_pull_request(pr) }
  end

  private

  attr_reader :use_labels,
    :exclude_labels,
    :exclude_titles,
    :exclude_repos,
    :include_repos,
    :organisation,
    :people,
    :github

  def present_pull_request(pull_request)
    repo = repo_name(pull_request)

    {
      title: pull_request.title,
      link: pull_request.html_url,
      author: pull_request.user.login,
      repo: repo,
      comments_count: count_comments(pull_request, repo),
      thumbs_up: count_thumbs_up(pull_request, repo),
      approved: approved?(pull_request, repo),
      updated: Date.parse(pull_request.updated_at.to_s),
      labels: labels(pull_request, repo),
    }
  end

  # https://developer.github.com/v3/search/#search-issues
  # returns up to 100 results per page.
  def pull_requests_from_github
    github.search_issues("is:pr state:open user:#{organisation} archived:false").items
  end

  def person_subscribed?(pull_request)
    people.empty? || people.include?("#{pull_request.user.login}")
  end

  def count_comments(pull_request, repo)
    pr = github.pull_request("#{organisation}/#{repo}", pull_request.number)
    pr.review_comments + pr.comments
  end

  def count_thumbs_up(pull_request, repo)
    response = github.issue_comments("#{organisation}/#{repo}", pull_request.number)
    comments_string = response.map(&:body).join
    thumbs_up = comments_string.scan(/:\+1:/).count
  end

  def approved?(pull_request, repo)
    reviews = github.get("repos/#{organisation}/#{repo}/pulls/#{pull_request.number}/reviews")
    reviews.any? { |review| review.state == 'APPROVED' }
  end

  def labels(pull_request, repo)
    return [] unless use_labels
    key = "#{organisation}/#{repo}/#{pull_request.number}".to_sym
    @labels[key] ||= github.labels_for_issue("#{organisation}/#{repo}", pull_request.number)
  end

  def hidden?(pull_request)
    repo = repo_name(pull_request)

    excluded_repo?(repo) ||
      excluded_label?(pull_request, repo) ||
      excluded_title?(pull_request.title) ||
      !person_subscribed?(pull_request) ||
      (include_repos.any? && !explicitly_included_repo?(repo))
  end

  def excluded_label?(pull_request, repo)
    return false unless exclude_labels.any?
    lowercase_label_names = labels(pull_request, repo).map { |l| l['name'].downcase }
    exclude_labels.any? { |e| lowercase_label_names.include?(e) }
  end

  def excluded_title?(title)
    exclude_titles.any? { |t| title.downcase.include?(t) }
  end

  def excluded_repo?(repo)
    return false unless exclude_repos.any?
    exclude_repos.include?(repo)
  end

  def explicitly_included_repo?(repo)
    return false unless include_repos.any?
    include_repos.include?(repo)
  end

  def repo_name(pr)
    pr.html_url.split("/")[4]
  end
end
