require 'octokit'

class GithubFetcher

  ORGANISATION = "alphagov"

  attr_accessor :people, :repos, :pull_requests

  def initialize(team_members_accounts, team_repos)
    @github = Octokit::Client.new(:access_token => ENV['GITHUB_TOKEN'])
    @github.user.login
    Octokit.auto_paginate = true

    @people = team_members_accounts
    @repos = team_repos.sort!
    @pull_requests = {}
  end

  def list_pull_requests
    @repos.each do |repo|
      response = @github.pull_requests("#{ORGANISATION}/#{repo}", state: "open")
      response.each do |pull_request|
        if pull_request_valid?(pull_request)
          @pull_requests[pull_request.title] = {}
          @pull_requests[pull_request.title]["title"] = pull_request.title
          @pull_requests[pull_request.title]["link"] = pull_request.html_url
          @pull_requests[pull_request.title]["author"] = pull_request.user.login
          @pull_requests[pull_request.title]["repo"] = repo
          @pull_requests[pull_request.title]["comments_count"] = count_comments(pull_request, repo)
        end
      end
    end
    @pull_requests
  end

private
  def pull_request_valid?(pull_request)
    return true if @people.include?("#{pull_request.user.login}")
    return false
  end

  def count_comments(pull_request, repo)
    review_comments = @github.pull_request("#{ORGANISATION}/#{repo}", pull_request.number).review_comments
    comments = @github.pull_request("#{ORGANISATION}/#{repo}", pull_request.number).comments
  	@total_comments = (review_comments + comments).to_s
  end

end
