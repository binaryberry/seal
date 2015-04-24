require 'github_api'

class Github_listener

	TEAM_ACCOUNTS = ["binaryberry", "evilstreak", "jennyd", "alicebartlett", "issyl0", "jackscotti"]
	ORGANISATION_ACCOUNT = "alphagov"

	attr_accessor :accounts, :list_pull_requests

	def initialize(accounts)
		@github = Github.new oauth_token: '1108c16e3e26af0ae16528af71f6fbd12b7bcfb0' #need to get a
		@accounts = accounts
		@list_pull_requests = []
	end


	def check_pr
		@accounts.each do |account|
			organisation_pr = @github.pull_requests.list user: account, repo: 'CV'
			organisation_pr.each do |pr|
				@list_pull_requests << pr["title"]
			end
		end
		@list_pull_requests
	end
end