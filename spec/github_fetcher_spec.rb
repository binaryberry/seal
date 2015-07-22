require 'spec_helper'
require './lib/github_fetcher'

describe 'GithubFetcher' do
  context '#list_pull_requests' do
    subject(:github_fetcher) { GithubFetcher.new(team_members_accounts, team_repos) }

    let(:fake_octokit_client) { double(Octokit::Client) }
    let(:team_members_accounts) { %w(binaryberry boffbowsh jackscotti tekin elliotcm tommyp mattbostock) }
    let(:team_repos) { %w(whitehall) }
    let(:pull_2266) do
      double(Sawyer::Resource,
             user: double(Sawyer::Resource, login: 'mattbostock'),
             title: '[FOR DISCUSSION ONLY] Remove Whitehall.case_study_preview_host',
             html_url: 'https://github.com/alphagov/whitehall/pull/2266',
             number: 2266,
             review_comments: 1,
             comments: 0,
             updated_at: '2015-07-13 01:00:44 UTC'
            )
    end
    let(:pull_2248) do
      double(Sawyer::Resource,
             user: double(Sawyer::Resource, login: 'tekin'),
             title: 'Remove all Import-related code',
             html_url: 'https://github.com/alphagov/whitehall/pull/2248',
             number: 2248,
             review_comments: 1,
             comments: 4,
             updated_at: '2015-07-17 01:00:44 UTC'
            )
    end

    before do
      REPO_NAME = "#{GithubFetcher::ORGANISATION}/whitehall"
      expect(Octokit::Client).to receive(:new).and_return(fake_octokit_client)
      expect(fake_octokit_client).to receive_message_chain('user.login')
      expect(fake_octokit_client).to receive(:pull_requests).and_return([pull_2266, pull_2248])
      expect(fake_octokit_client).to receive(:pull_request).at_least(:once).with(REPO_NAME, 2248).and_return(pull_2248)
      expect(fake_octokit_client).to receive(:pull_request).at_least(:once).with(REPO_NAME, 2266).and_return(pull_2266)
    end

    it "displays open pull requests open on the team's repos by a team member" do
      OPEN_PRS = {
        '[FOR DISCUSSION ONLY] Remove Whitehall.case_study_preview_host' =>
        {
          'title' => '[FOR DISCUSSION ONLY] Remove Whitehall.case_study_preview_host',
          'link' => 'https://github.com/alphagov/whitehall/pull/2266',
          'author' => 'mattbostock',
          'repo' => 'whitehall',
          'comments_count' => '1',
          'updated' => Date.parse('2015-07-13 ((2457217j,0s,0n),+0s,2299161j)')
        },

        'Remove all Import-related code' =>
        {
          'title' => 'Remove all Import-related code',
          'link' => 'https://github.com/alphagov/whitehall/pull/2248',
          'author' => 'tekin',
          'repo' => 'whitehall',
          'comments_count' => '5',
          'updated' => Date.parse('2015-07-17 ((2457221j,0s,0n),+0s,2299161j)')
        }
      }

      expect(github_fetcher.list_pull_requests).to match OPEN_PRS
    end
  end
end
