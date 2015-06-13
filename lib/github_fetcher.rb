require 'github_api'

class GithubFetcher

	TEAM_MEMBERS_ACCOUNTS = ["binaryberry", "jamiecobbett", "boffbowsh", "alicebartlett", "benilovj", "fofr", "russellthorn", "edds"]
	ORGANISATION = "alphagov"
	TEAM_REPOS = %w(maslow signonotron2 short-url-manager support feedback frontend specialist-publisher publisher whitehall govuk_content_api release metadata-api travel-advice-publisher info-frontend government-frontend support-api external-link-tracker specialist-frontend static asset-manager content-store url-arbiter content-register)

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
				@pull_requests[pull_request.title] = [pull_request.html_url, repo] if pull_request_valid?(pull_request)
			end
		end
		@pull_requests
	end

private
	def pull_request_valid?(pull_request)
		return true if TEAM_MEMBERS_ACCOUNTS.include?("#{pull_request.user.login}") && pull_request.merged? == false
		return false
	end
end
