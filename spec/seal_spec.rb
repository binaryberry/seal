require 'spec_helper'
require './lib/seal'

describe Seal do
  subject(:seal) { described_class.new(team, mood) }
  let(:mood) { 'angry' }

  describe '#bark' do
    before do
      expect(YAML).to receive(:load_file).and_return(org_config)
      expect(MessageBuilder).to receive(:new)
        .exactly(number_of_teams).times
        .and_return(instance_double(MessageBuilder, build: nil, poster_mood: mood))
      expect(SlackPoster).to receive(:new)
        .exactly(number_of_teams).times
        .and_return(instance_double(SlackPoster, send_request: nil))
    end

    context 'given a team "tigers"' do
      let(:team) { 'tigers' }
      let(:number_of_teams) { 1 }
      let(:org_config) do
        {
          'tigers' => {
            'members' => [],
            'repos' => ['stripes'],
            'use_labels' => nil,
            'exclude_labels' => nil,
            'exclude_titles' => nil,
          }
        }
      end

      it 'fetches PRs for the tigers and only the tigers' do
        expect(GithubFetcher)
          .to receive(:new)
          .with([], ['stripes'], nil, nil, nil)
          .and_return(instance_double(GithubFetcher, list_pull_requests: []))

        seal.bark
      end
    end

    context 'given no team' do
      let(:team) { nil }

      context "but two teams, lions and tigers in the organisation's config" do
        let(:number_of_teams) { 2 }
        let(:org_config) do
          {
            'lion' => {
              'members' => [],
              'repos' => ['leo'],
              'use_labels' => nil,
              'exclude_labels' => nil,
              'exclude_titles' => nil,
            },
            'tigers' => {
              'members' => [],
              'repos' => ['stripes'],
              'use_labels' => nil,
              'exclude_labels' => nil,
              'exclude_titles' => nil,
            }
          }
        end

        it 'fetches PRs for the lions and the tigers' do
          expect(GithubFetcher)
            .to receive(:new)
            .with([], ['leo'], nil, nil, nil)
            .and_return(instance_double(GithubFetcher, list_pull_requests: []))

          expect(GithubFetcher)
            .to receive(:new)
            .with([], ['stripes'], nil, nil, nil)
            .and_return(instance_double(GithubFetcher, list_pull_requests: []))

          seal.bark
        end
      end
    end
  end
end
