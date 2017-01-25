require 'spec_helper'
require './lib/message_builder'

describe MessageBuilder do
  subject(:message_builder) { MessageBuilder.new(pull_requests) }

  let(:no_pull_requests) { {} }
  let(:recent_pull_requests) do
    {
      'Remove all Import-related code' => {
        'title' => 'Remove all Import-related code',
        'link' => 'https://github.com/alphagov/whitehall/pull/2248',
        'author' => 'tekin',
        'repo' => 'whitehall',
        'comments_count' => '5',
        'thumbs_up' => '0',
        'approved' => true,
        'updated' => Date.parse('2015-07-17 ((2457221j, 0s, 0n), +0s, 2299161j)'),
        'labels' => []
      }
    }
  end

  let(:old_and_new_pull_requests) do
    {
      '[FOR DISCUSSION ONLY] Remove Whitehall.case_study_preview_host' => {
        'title' => '[FOR DISCUSSION ONLY] Remove Whitehall.case_study_preview_host',
        'link' => 'https://github.com/alphagov/whitehall/pull/2266',
        'author' => 'mattbostock',
        'repo' => 'whitehall',
        'comments_count' => '1',
        'thumbs_up' => '1',
        'approved' => false,
        'updated' => Date.parse('2015-07-13 ((2457217j, 0s, 0n), +0s, 2299161j)'),
        'labels' => []
      },
      'Remove all Import-related code' => {
        'title' => 'Remove all Import-related code',
        'link' => 'https://github.com/alphagov/whitehall/pull/2248',
        'author' => 'tekin',
        'repo' => 'whitehall',
        'comments_count' => '5',
        'thumbs_up' => '0',
        'approved' => false,
        'updated' => Date.parse('2015-07-17 ((2457221j, 0s, 0n), +0s, 2299161j)'),
        'labels' => []
      }
    }
  end

  before { Timecop.freeze(Time.local(2015, 07, 18)) }

  context 'with labels' do
    let(:mood) { 'informative' }
    let(:pull_requests) do
      {
        'My WIP' => {
          'title' => 'My WIP',
          'link' => 'https://github.com/org/repo/pull/42',
          'author' => 'Agatha Christie',
          'repo' => 'repo',
          'comments_count' => '0',
          'thumbs_up' => '0',
          'approved' => false,
          'updated' => Date.today,
          'labels' => [
            { 'name' => 'wip' },
            { 'name' => 'blocked' }
          ]
        }
      }
    end

    it 'includes the labels in the built message' do
      expect(message_builder.build).to include(
        '[wip] [blocked] <https://github.com/org/repo/pull/42|My WIP> - 0 comments'
      )
    end
  end

  context 'pull requests are recent' do
    let(:pull_requests) { recent_pull_requests }

    it 'builds informative message' do
      expect(message_builder.build).to eq("Hello team! \n\n Here are the pull requests that need to be reviewed today:\n\n1) *whitehall* | tekin | updated yesterday | :white_check_mark: \n<https://github.com/alphagov/whitehall/pull/2248|Remove all Import-related code> - 5 comments\n\nMerry reviewing!")
    end

    it 'has an informative poster mood' do
      message_builder.build
      expect(message_builder.poster_mood).to eq("informative")
    end
  end

  context 'no pull requests' do
    let(:pull_requests) { no_pull_requests }

    it 'builds seal of approval message' do
      expect(message_builder.build).to eq("Aloha team! It's a beautiful day! :happyseal: :happyseal: :happyseal:\n\nNo pull requests to review today! :rainbow: :sunny: :metal: :tada:")
    end

    it 'has an approval poster mood' do
      message_builder.build
      expect(pull_requests).to eq({})
      expect(message_builder.poster_mood).to eq("approval")
    end

  end

  context 'there are some PRs that are over 2 days old' do
    let(:mood) { 'angry' }
    let(:pull_requests) { old_and_new_pull_requests }
      context "and some recent ones" do
        before { Timecop.freeze(Time.local(2015, 07, 18)) }
        it 'builds message' do
          expect(message_builder.build).to eq("AAAAAAARGH! This pull request has not been updated in over 2 days.\n\n1) *whitehall* | mattbostock | updated 5 days ago | 1 :+1:\n<https://github.com/alphagov/whitehall/pull/2266|[FOR DISCUSSION ONLY] Remove Whitehall.case_study_preview_host> - 1 comment\n\nRemember each time you forget to review your pull requests, a baby seal dies.\n    \n\nThere are also these pull requests that need to be reviewed today:\n\n1) *whitehall* | tekin | updated yesterday\n<https://github.com/alphagov/whitehall/pull/2248|Remove all Import-related code> - 5 comments\n ")
        end
      end

      context "but no recent ones" do
        before { Timecop.freeze(Time.local(2015, 07, 16)) }
        it 'builds message' do
          expect(message_builder.build).to eq("AAAAAAARGH! This pull request has not been updated in over 2 days.\n\n1) *whitehall* | mattbostock | updated 3 days ago | 1 :+1:\n<https://github.com/alphagov/whitehall/pull/2266|[FOR DISCUSSION ONLY] Remove Whitehall.case_study_preview_host> - 1 comment\n\nRemember each time you forget to review your pull requests, a baby seal dies.\n    \n\nThere are also these pull requests that need to be reviewed today:\n\n1) *whitehall* | tekin | updated -1 days ago\n<https://github.com/alphagov/whitehall/pull/2248|Remove all Import-related code> - 5 comments\n ")
        end
      end
    it 'has an angry poster mood' do
      message_builder.build
      expect(message_builder.poster_mood).to eq("angry")
    end
  end

  context 'rotting' do
    let(:pull_request) do
      { 'title' => '[FOR DISCUSSION ONLY] Remove Whitehall.case_study_preview_host', 'link' => 'https://github.com/alphagov/whitehall/pull/2266', 'author' => 'mattbostock', 'repo' => 'whitehall', 'comments_count' => '1', 'thumbs_up' => '0', 'updated' => Date.parse('2015-07-13 ((2457217j,0s,0n),+0s,2299161j)') }
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
