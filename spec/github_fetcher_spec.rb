require 'spec_helper'
require './lib/github_fetcher'

describe 'GithubFetcher' do
  subject(:github_fetcher) do
    GithubFetcher.new(team_members_accounts,
                      use_labels,
                      exclude_labels,
                      exclude_titles,
                      exclude_repos,
                      include_repos
                     )
  end

  let(:fake_octokit_client) { double(Octokit::Client) }
  let(:whitehall_repo_name) { "#{GithubFetcher::ORGANISATION}/whitehall" }
  let(:whitehall_rebuild_repo_name) { "#{GithubFetcher::ORGANISATION}/whitehall-rebuild" }
  let(:blocked_and_wip) do
    [
      {
        'url' => 'https://api.github.com/repos/alphagov/whitehall/labels/blocked',
        'name' => 'blocked',
        'color' => 'e11d21'
      },
      {
        'url' => 'https://api.github.com/repos/alphagov/whitehall/labels/wip',
        'name' => 'wip',
        'color' => 'fbca04'
      }
    ]
  end

  let(:expected_open_prs) do
    {
      '[FOR DISCUSSION ONLY] Remove Whitehall.case_study_preview_host' =>
        {
          'title' => '[FOR DISCUSSION ONLY] Remove Whitehall.case_study_preview_host',
          'link' => 'https://github.com/alphagov/whitehall/pull/2266',
          'author' => 'mattbostock',
          'repo' => 'whitehall',
          'comments_count' => '1',
          'thumbs_up' => '1',
          'approved' => false,
          'updated' => Date.parse('2015-07-13 ((2457217j,0s,0n),+0s,2299161j)'),
          'labels' => []
        },

      'Remove all Import-related code' =>
        {
          'title' => 'Remove all Import-related code',
          'link' => 'https://github.com/alphagov/whitehall-rebuild/pull/2248',
          'author' => 'tekin',
          'repo' => 'whitehall-rebuild',
          'comments_count' => '5',
          'thumbs_up' => '0',
          'approved' => true,
          'updated' => Date.parse('2015-07-17 ((2457221j,0s,0n),+0s,2299161j)'),
          'labels' => []
        }
    }
  end
  let(:exclude_labels) { nil }
  let(:exclude_titles) { nil }
  let(:exclude_repos) { nil }
  let(:include_repos) { nil }
  let(:team_members_accounts) { %w(binaryberry boffbowsh jackscotti tekin elliotcm tommyp mattbostock) }
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
           html_url: 'https://github.com/alphagov/whitehall-rebuild/pull/2248',
           number: 2248,
           review_comments: 1,
           comments: 4,
           updated_at: '2015-07-17 01:00:44 UTC'
          )
  end
  let(:comments_2266) do [
      "You should add more seal images on the front end",
      "Sure! I have done it now",
      "LGTM :+1:"
    ].map { |body| double(Sawyer::Resource, body: body)}
  end

  let(:comments_2248) do [
      "Could you embed a seal song?",
      "Sure! Please send me the recording"
    ].map { |body| double(Sawyer::Resource, body: body)}
  end

  let(:reviews_2248) do
    [
      double(Sawyer::Resource, state: "APPROVED" )
    ]
  end

  let(:reviews_2266) { [] }

  before do
    expect(Octokit::Client).to receive(:new).and_return(fake_octokit_client)
    expect(fake_octokit_client).to receive_message_chain('user.login')
    expect(fake_octokit_client).to receive(:auto_paginate=).with(true)
    expect(fake_octokit_client).to receive(:search_issues).with("is:pr state:open user:alphagov").and_return(double(items: [pull_2266, pull_2248]))

    allow(fake_octokit_client).to receive(:issue_comments).with(whitehall_repo_name, 2266).and_return(comments_2266)
    allow(fake_octokit_client).to receive(:issue_comments).with(whitehall_rebuild_repo_name, 2248).and_return(comments_2248)

    allow(fake_octokit_client).to receive(:pull_request).with(whitehall_rebuild_repo_name, 2248).and_return(pull_2248)
    allow(fake_octokit_client).to receive(:pull_request).with(whitehall_repo_name, 2266).and_return(pull_2266)
    allow(fake_octokit_client).to receive(:get).with(%r"repos/alphagov/[\w-]+/pulls/2248/reviews").and_return(reviews_2248)
    allow(fake_octokit_client).to receive(:get).with(%r"repos/alphagov/[\w-]+/pulls/2266/reviews").and_return(reviews_2266)
  end

  shared_examples_for 'fetching from GitHub' do
    describe '#list_pull_requests' do
      it "displays open pull requests open on the team's repos by a team member" do
        expect(github_fetcher.list_pull_requests).to match expected_open_prs
      end
    end
  end

  context 'labels turned on' do
    let(:use_labels) { true }

    before do
      allow(fake_octokit_client).to receive(:labels_for_issue).with(whitehall_rebuild_repo_name, 2248).and_return(blocked_and_wip)
      allow(fake_octokit_client).to receive(:labels_for_issue).with(whitehall_repo_name, 2266).and_return([])

      expected_open_prs['Remove all Import-related code']['labels'] = blocked_and_wip if expected_open_prs['Remove all Import-related code']
    end

    context 'excluding nothing' do
      it_behaves_like 'fetching from GitHub'
    end

    context 'excluding "designer" label' do
      let(:exclude_labels) { ['designer'] }

      it_behaves_like 'fetching from GitHub'
    end

    context 'excluding "WIP" label' do
      let(:exclude_labels) { ['WIP'] }

      it 'filters out the WIP' do
        titles = github_fetcher.list_pull_requests.keys

        expect(titles).not_to include 'Remove all Import-related code'
        expect(titles).to include '[FOR DISCUSSION ONLY] Remove Whitehall.case_study_preview_host'
      end
    end

    context 'excluding "wip" label' do
      let(:exclude_labels) { ['wip'] }

      it 'filters out the wip' do
        titles = github_fetcher.list_pull_requests.keys

        expect(titles).not_to include 'Remove all Import-related code'
        expect(titles).to include '[FOR DISCUSSION ONLY] Remove Whitehall.case_study_preview_host'
      end
    end

    context 'excluding "whitehall-rebuild" repo' do
      let(:exclude_repos) { ['whitehall-rebuild'] }

      it 'filters out PRs for the "whitehall-rebuild" repo' do
        titles = github_fetcher.list_pull_requests.keys

        expect(titles).to match_array(['[FOR DISCUSSION ONLY] Remove Whitehall.case_study_preview_host'])
      end
    end

    context 'excluding "whitehall-rebuild" repo' do
      let(:include_repos) { ['whitehall-rebuild'] }

      it 'filters out PRs NOT from the "whitehall-rebuild" repo' do
        titles = github_fetcher.list_pull_requests.keys

        expect(titles).to match_array(['Remove all Import-related code'])
      end
    end
  end

  context 'labels turned off' do
    let(:use_labels) { false }

    it_behaves_like 'fetching from GitHub'
    context 'title exclusions' do
      context 'excluding no titles' do
        it_behaves_like 'fetching from GitHub'
      end

      context 'excluding "BLAH BLAH BLAH" title' do
        let(:exclude_titles) { ['BLAH BLAH BLAH'] }

        it_behaves_like 'fetching from GitHub'
      end

      context 'excluding "DISCUSSION" title' do
        let(:exclude_titles) { ['FOR DISCUSSION ONLY'] }

        it 'filters out the DISCUSSION' do
          titles = github_fetcher.list_pull_requests.keys

          expect(titles).not_to include '[FOR DISCUSSION ONLY] Remove Whitehall.case_study_preview_host'
          expect(titles).to include 'Remove all Import-related code'
        end
      end

      context 'excluding "discussion" title' do
        let(:exclude_titles) { ['for discussion only'] }

        it 'filters out the discussion' do
          titles = github_fetcher.list_pull_requests.keys

          expect(titles).not_to include '[FOR DISCUSSION ONLY] Remove Whitehall.case_study_preview_host'
          expect(titles).to include 'Remove all Import-related code'
        end
      end

      context 'excluding "whitehall-rebuild" repo' do
        let(:exclude_repos) { ['whitehall-rebuild'] }

        it 'filters out PRs for the "whitehall-rebuild" repo' do
          titles = github_fetcher.list_pull_requests.keys

          expect(titles).to match_array(['[FOR DISCUSSION ONLY] Remove Whitehall.case_study_preview_host'])
        end
      end
    end
  end
end
