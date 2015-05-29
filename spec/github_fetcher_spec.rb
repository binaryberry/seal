require 'spec_helper'
require './lib/github_fetcher'

describe 'github_listener' do

	let(:team_members_accounts) {["binaryberry"]}
	let(:team_repos) {["CV", "bookmark-collector"]}
	let(:github_fetcher) { GithubFetcher.new(team_members_accounts, team_repos) }

	context "list_pull_requests" do
		it "should display open pull requests open on the team's repos by a team member" do
			expect(github_fetcher.list_pull_requests).to eq(["testing things", "minor change"])
		end
	end


end