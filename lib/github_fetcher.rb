require 'github_api'

class GithubFetcher

	ORGANISATION = "alphagov"

	attr_accessor :people, :repos, :pull_requests

	def initialize(team_members_accounts, team_repos)
		@github = Github.new oauth_token: ENV['GITHUB_TOKEN'], auto_pagination: true
		@people = team_members_accounts
		@repos = team_repos
		@pull_requests = {}
	end

	def list_pull_requests
		@repos.each do |repo|
			response = @github.pull_requests.list user: "#{ORGANISATION}", repo: "#{repo}"
			response.body.each do |pull_request|
				if pull_request_valid?(pull_request)
					@pull_requests[pull_request.title] = {}
					@pull_requests[pull_request.title]["title"] = pull_request.title
					@pull_requests[pull_request.title]["link"] = pull_request.html_url
					@pull_requests[pull_request.title]["repo"] = repo
				end
			end
		end
		@pull_requests
	end

private
	def pull_request_valid?(pull_request)
		return true if @people.include?("#{pull_request.user.login}") && pull_request.merged? == false
		return false
	end
end
