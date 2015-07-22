require 'spec_helper'
require './lib/message_builder'
require 'timecop'

describe MessageBuilder do
  subject(:message_builder) { MessageBuilder.new(pull_requests, mood) }

  let(:no_pull_requests) { {} }
  let(:old_pull_requests)   { { '[FOR DISCUSSION ONLY] Remove Whitehall.case_study_preview_host' => { 'title' => '[FOR DISCUSSION ONLY] Remove Whitehall.case_study_preview_host', 'link' => 'https://github.com/alphagov/whitehall/pull/2266', 'author' => 'mattbostock', 'repo' => 'whitehall', 'comments_count' => '1', 'updated' => Date.parse('2015-07-13 ((2457217j,0s,0n),+0s,2299161j)') }, 'Remove all Import-related code' => { 'title' => 'Remove all Import-related code', 'link' => 'https://github.com/alphagov/whitehall/pull/2248', 'author' => 'tekin', 'repo' => 'whitehall', 'comments_count' => '5', 'updated' => Date.parse('2015-07-17 ((2457221j,0s,0n),+0s,2299161j)') } } }

  context 'informative' do
    let(:mood) { 'informative' }

    context 'old pull requests' do
      let(:pull_requests) { old_pull_requests }

      it 'builds message' do
        expect(message_builder.build).to eq("Good morning team! \n\n Here are the pull requests that need to be reviewed today:\n\n1) *whitehall* | mattbostock\n<https://github.com/alphagov/whitehall/pull/2266|[FOR DISCUSSION ONLY] Remove Whitehall.case_study_preview_host> - 1 comment\n2) *whitehall* | tekin\n<https://github.com/alphagov/whitehall/pull/2248|Remove all Import-related code> - 5 comments\n\nMerry reviewing!")
      end
    end

    context 'no PRs' do
      let(:pull_requests) { no_pull_requests }

      it 'builds happy message' do
        expect(message_builder.build).to eq("Good morning team! It's a beautiful day! :happyseal: :happyseal: :happyseal:\n\nNo pull requests to review today! :rainbow: :sunny: :metal: :tada:")
      end
    end
  end

  context 'angry' do
    let(:mood) { 'angry' }

    context 'old pull requests' do
      let(:pull_requests) { old_pull_requests }

      it 'builds message' do
        expect(message_builder.build).to eq("AAAAAAARGH! These pull requests have not been updated in over 2 days.\n\n1) *whitehall* | mattbostock\n<https://github.com/alphagov/whitehall/pull/2266|[FOR DISCUSSION ONLY] Remove Whitehall.case_study_preview_host> - 1 comment\n2) *whitehall* | tekin\n<https://github.com/alphagov/whitehall/pull/2248|Remove all Import-related code> - 5 comments\n\n\n Remember each time you time you forget to review your pull requests, a baby seal dies.")
      end
    end

    context 'no old PRs' do
      let(:pull_requests) { no_pull_requests }

      it 'produces an empty string' do
        expect(message_builder.build).to be_empty
      end
    end

    context 'rotting' do
      let(:pull_request) do
        { 'title' => '[FOR DISCUSSION ONLY] Remove Whitehall.case_study_preview_host', 'link' => 'https://github.com/alphagov/whitehall/pull/2266', 'author' => 'mattbostock', 'repo' => 'whitehall', 'comments_count' => '1', 'updated' => Date.parse('2015-07-13 ((2457217j,0s,0n),+0s,2299161j)') }
      end

      let(:pull_requests) { [pull_request] }

      context 'old PR' do
        before do
          Timecop.freeze(Time.local(2015, 07, 16))
        end

        it 'is rotten' do
          expect(message_builder).to be_rotten(pull_request)
        end

        after do
          Timecop.return
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
end
