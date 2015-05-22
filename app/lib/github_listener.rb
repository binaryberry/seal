require 'github_api'

class Github_listener

	TEAM_ACCOUNTS = ["binaryberry", "evilstreak", "jennyd", "alicebartlett", "issyl0", "jackscotti"]
	ORGANISATION_ACCOUNT = "alphagov"

	attr_accessor :accounts, :list_pull_requests, :organisation, :org_repos_list

	def initialize(accounts, organisation)
		@github = Github.new oauth_token: ENV['GITHUB_TOKEN'], auto_pagination: true
		@organisation = organisation
		@accounts = accounts
		@list_pull_requests = []
		@org_repos_list = []
	end

	def list_repos(organisation)
		for i in 1..10
			response = @github.repos.list org: "#{organisation}", PARAM_PAGE: i
			add_repo_names(response)
		end
		@org_repos_list
	end



	def check_pr
		list_repos(@organisation)
		@org_repos_list.each do |repo|
			pull_request = @github.pull_requests.list user: "#{organisation}", repo: repo
			@list_pull_requests << pull_request
		end
		@list_pull_requests
	end

private

	def add_repo_names(response)
		response_body = response.body
		response_body.each{|repo| @org_repos_list << repo.name}
		@org_repos_list
	end

end