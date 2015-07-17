require 'spec_helper'
require './lib/github_fetcher'
require 'rubygems'

  describe 'github_fetcher' do

    let(:team_members_accounts) {["binaryberry", "boffbowsh", "jackscotti", "tekin", "elliotcm", "tommyp", "mattbostock"]}
    let(:team_repos) {["whitehall"]}
    let(:github_fetcher) { GithubFetcher.new(team_members_accounts, team_repos) }

    context "list_pull_requests" do
      it "should display open pull requests open on the team's repos by a team member" do
        expect(github_fetcher.list_pull_requests).to eq({"[FOR DISCUSSION ONLY] Remove Whitehall.case_study_preview_host"=>{"title"=>"[FOR DISCUSSION ONLY] Remove Whitehall.case_study_preview_host", "link"=>"https://github.com/alphagov/whitehall/pull/2266", "author"=>"mattbostock", "repo"=>"whitehall", "comments_count"=>"1", "updated"=> Date.parse("2015-07-13 ((2457217j,0s,0n),+0s,2299161j)")}, "Remove all Import-related code"=>{"title"=>"Remove all Import-related code", "link"=>"https://github.com/alphagov/whitehall/pull/2248", "author"=>"tekin", "repo"=>"whitehall", "comments_count"=>"5", "updated"=>Date.parse("2015-07-17 ((2457221j,0s,0n),+0s,2299161j)")}})
      end
    end
  end
