require 'rails_helper'
# require 'support/fake_github'

describe 'github_listener' do

	let(:team_members_accounts) {["binaryberry"]}
	let(:team_repos) {["CV", "bookmark-collector"]}
	let(:github_listener) { GithubListener.new(team_members_accounts, team_repos) }

	context "list_pull_requests" do
		it "should display open pull requests open on the team's repos by a team member" do
			expect(github_listener.list_pull_requests).to eq(["testing things", "minor change"])
		end
	end


end