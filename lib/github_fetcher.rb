require 'github_api'

class GithubFetcher

	TEAM_MEMBERS_ACCOUNTS = ["binaryberry", "jamiecobbett", "boffbowsh", "alicebartlett", "benilovj", "fofr", "russellthorn"]
	TEAM_REPOS = %w(maslow signonotron2 short-url-manager support feedback frontend specialist-publisher publisher whitehall govuk_content_api release metadata-api travel-advice-publisher info-frontend government-frontend support-api external-link-tracker specialist-frontend static asset-manager content-store url-arbiter content-register)

	attr_accessor :people, :repos, :pull_requests

	def initialize(team_members_accounts, team_repos)
		@github = Github.new oauth_token: ENV['GITHUB_TOKEN'], auto_pagination: true
		@people = team_members_accounts
		@repos = team_repos
		@pull_requests = []
	end

	def list_pull_requests
		@repos.each do |repo|
			@people.each do |person|
				error = "no" #this is very ugly - ask tech person for advice
				begin
					response = @github.pull_requests.list user: "#{person}", repo: "#{repo}"
				rescue
					error = "yes"
				end
				response.body.each{|pull_request| @pull_requests << pull_request.title if pull_request.merged? == false} unless error == "yes"
			end
		end
		@pull_requests
	end
end
