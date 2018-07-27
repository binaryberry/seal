require 'spec_helper'
require './lib/message_builder'

RSpec.describe MessageBuilder do
  let(:team) { double(:team) }
  let(:github_fetcher) { double(:github_fetcher, list_pull_requests: pull_requests)}
  subject(:message_builder) { MessageBuilder.new(team) }

  let(:no_pull_requests) { {} }
  let(:recent_pull_requests) do
    [
      {
        title: 'Remove all Import-related code',
        link: 'https://github.com/alphagov/whitehall/pull/2248',
        author: 'tekin',
        repo: 'whitehall',
        comments_count: 5,
        thumbs_up: 0,
        approved: true,
        updated: Date.parse('2015-07-17 ((2457221j, 0s, 0n), +0s, 2299161j)'),
        labels: [],
      }
    ]
  end

  let(:old_and_new_pull_requests) do
    [
      {
        title: '[FOR DISCUSSION ONLY] Remove Whitehall.case_study_preview_host',
        link: 'https://github.com/alphagov/whitehall/pull/2266',
        author: 'mattbostock',
        repo: 'whitehall',
        comments_count: 1,
        thumbs_up: 1,
        approved: false,
        updated: Date.parse('2015-07-13 ((2457217j, 0s, 0n), +0s, 2299161j)'),
        labels: [],
      },
      {
        title: 'Remove all Import-related code',
        link: 'https://github.com/alphagov/whitehall/pull/2248',
        author: 'tekin',
        repo: 'whitehall',
        comments_count: 5,
        thumbs_up: 0,
        approved: false,
        updated: Date.parse('2015-07-17 ((2457221j, 0s, 0n), +0s, 2299161j)'),
        labels: [],
      },
      {
        title: 'Add extra examples to the specs',
        link: 'https://github.com/alphagov/seal/pull/9999',
        author: 'elliotcm',
        repo: 'seal',
        comments_count: 5,
        thumbs_up: 0,
        approved: false,
        updated: Date.parse('2015-07-17 ((2457221j, 0s, 0n), +0s, 2299161j)'),
        labels: [],
      },
    ]
  end

  before do
    Timecop.freeze(Time.local(2015, 07, 18))

    allow(GithubFetcher).to receive(:new).with(team).and_return(github_fetcher)
  end

  context 'with labels' do
    let(:mood) { 'informative' }
    let(:pull_requests) do
      [
        {
          title: 'My WIP',
          link: 'https://github.com/org/repo/pull/42',
          author: 'Agatha Christie',
          repo: 'repo',
          comments_count: 0,
          thumbs_up: 0,
          approved: false,
          updated: Date.today,
          labels: [
            { 'name' => 'wip' },
            { 'name' => 'blocked' }
          ],
        },
      ]
    end

    it 'includes the labels in the built message' do
      expect(message_builder.build.text).to include(
        '[wip] [blocked] <https://github.com/org/repo/pull/42|My WIP> - 0 comments'
      )
    end
  end

  context 'pull requests are recent' do
    let(:pull_requests) { recent_pull_requests }

    it 'builds informative message' do
      expect(message_builder.build.text).to eq("Hello team!\n\nHere are the pull requests that need to be reviewed today:\n\n1) *whitehall* | tekin | updated yesterday | :white_check_mark: \n<https://github.com/alphagov/whitehall/pull/2248|Remove all Import-related code> - 5 comments\n\nMerry reviewing!")
    end

    it 'has an informative poster mood' do
      expect(message_builder.build.mood).to eq("informative")
    end
  end

  context 'no pull requests' do
    let(:pull_requests) { no_pull_requests }

    it 'builds seal of approval message' do
      expect(message_builder.build.text).to eq("Aloha team! It's a beautiful day! :happyseal: :happyseal: :happyseal:\n\nNo pull requests to review today! :rainbow: :sunny: :metal: :tada:")
    end

    it 'has an approval poster mood' do
      expect(message_builder.build.mood).to eq("approval")
    end
  end

  context 'there are some PRs that are over 2 days old' do
    let(:mood) { 'angry' }
    let(:pull_requests) { old_and_new_pull_requests }

    context "and some recent ones" do
      before { Timecop.freeze(Time.local(2015, 07, 18)) }
      it 'builds message' do
        expect(message_builder.build.text).to eq("AAAAAAARGH! This pull request has not been updated in over 2 days.\n\n1) *whitehall* | mattbostock | updated 5 days ago | 1 :+1:\n<https://github.com/alphagov/whitehall/pull/2266|[FOR DISCUSSION ONLY] Remove Whitehall.case_study_preview_host> - 1 comment\n\nRemember each time you forget to review your pull requests, a baby seal dies.\n\n\nThere are also these pull requests that need to be reviewed today:\n\n1) *whitehall* | tekin | updated yesterday\n<https://github.com/alphagov/whitehall/pull/2248|Remove all Import-related code> - 5 comments\n2) *seal* | elliotcm | updated yesterday\n<https://github.com/alphagov/seal/pull/9999|Add extra examples to the specs> - 5 comments")
      end
    end

    context "but no recent ones" do
      before { Timecop.freeze(Time.local(2015, 07, 16)) }
      it 'builds message' do
        expect(message_builder.build.text).to eq("AAAAAAARGH! This pull request has not been updated in over 2 days.\n\n1) *whitehall* | mattbostock | updated 3 days ago | 1 :+1:\n<https://github.com/alphagov/whitehall/pull/2266|[FOR DISCUSSION ONLY] Remove Whitehall.case_study_preview_host> - 1 comment\n\nRemember each time you forget to review your pull requests, a baby seal dies.\n\n\nThere are also these pull requests that need to be reviewed today:\n\n1) *whitehall* | tekin | updated -1 days ago\n<https://github.com/alphagov/whitehall/pull/2248|Remove all Import-related code> - 5 comments\n2) *seal* | elliotcm | updated -1 days ago\n<https://github.com/alphagov/seal/pull/9999|Add extra examples to the specs> - 5 comments")
      end
    end

    it 'has an angry poster mood' do
      expect(message_builder.build.mood).to eq("angry")
    end
  end

  context 'rotting' do
    let(:pull_request) do
      {
        title: '[FOR DISCUSSION ONLY] Remove Whitehall.case_study_preview_host',
        link: 'https://github.com/alphagov/whitehall/pull/2266',
        author: 'mattbostock',
        repo: 'whitehall',
        comments_count: '1',
        thumbs_up: '0',
        updated: Date.parse('2015-07-13 ((2457217j,0s,0n),+0s,2299161j)'),
      }
    end

    let(:pull_requests) { [pull_request] }

    context 'old PR' do
      before do
        Timecop.freeze(Time.local(2015, 07, 16))
      end

      it 'is rotten' do
        expect(message_builder).to be_rotten(pull_request)
      end
    end

    context 'recent PR' do
      before do
        Timecop.freeze(Time.local(2015, 07, 15))
      end

      it 'is not rotten' do
        expect(message_builder).to_not be_rotten(pull_request)
      end
    end
  end
end
