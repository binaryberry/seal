require 'spec_helper'
require './lib/github_fetcher'
require 'rubygems'

  describe 'github_fetcher' do

    let(:team_members_accounts) {["binaryberry", "boffbowsh", "jackscotti", "tekin", "elliotcm", "tommyp"]}
    let(:team_repos) {["whitehall"]}
    let(:github_fetcher) { GithubFetcher.new(team_members_accounts, team_repos) }

    context "list_pull_requests" do
      it "should display open pull requests open on the team's repos by a team member" do
        expect(github_fetcher.list_pull_requests).to eq({"[review but do not merge]Rename Topic to PolicyArea in Publisher UI"=>{"title"=>"[review but do not merge]Rename Topic to PolicyArea in Publisher UI", "link"=>"https://github.com/alphagov/whitehall/pull/2249", "author"=>"jackscotti", "repo"=>"whitehall", "comments_count"=>"5"}, "Remove all Import-related code"=>{"title"=>"Remove all Import-related code", "link"=>"https://github.com/alphagov/whitehall/pull/2248", "author"=>"tekin", "repo"=>"whitehall", "comments_count"=>"3"}, "Remove worldwide priority data."=>{"title"=>"Remove worldwide priority data.", "link"=>"https://github.com/alphagov/whitehall/pull/2247", "author"=>"elliotcm", "repo"=>"whitehall", "comments_count"=>"0"}, "Remove worldwide priority code."=>{"title"=>"Remove worldwide priority code.", "link"=>"https://github.com/alphagov/whitehall/pull/2246", "author"=>"elliotcm", "repo"=>"whitehall", "comments_count"=>"0"}, "Use gds-ruby-styleguide to provide Rubocop"=>{"title"=>"Use gds-ruby-styleguide to provide Rubocop", "link"=>"https://github.com/alphagov/whitehall/pull/2228", "author"=>"boffbowsh", "repo"=>"whitehall", "comments_count"=>"0"}, "Editions can be important"=>{"title"=>"Editions can be important", "link"=>"https://github.com/alphagov/whitehall/pull/2225", "author"=>"tommyp", "repo"=>"whitehall", "comments_count"=>"6"}, "Convert worldwide priorities to policy papers."=>{"title"=>"Convert worldwide priorities to policy papers.", "link"=>"https://github.com/alphagov/whitehall/pull/2223", "author"=>"elliotcm", "repo"=>"whitehall", "comments_count"=>"3"}})
      end
    end
  end
