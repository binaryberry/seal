require 'spec_helper'
require './lib/seal'

describe Seal do
  subject(:seal) { described_class.new(team) }
  let(:org_config) do
    {
      'lion' => {
        'members' => [],
        'use_labels' => nil,
        'exclude_labels' => nil,
        'exclude_titles' => nil,
        'exclude_repos' => nil,
        'include_repos' => nil,
      },
      'tigers' => {
        'members' => [],
        'use_labels' => nil,
        'exclude_labels' => nil,
        'exclude_titles' => nil,
        'exclude_repos' => nil,
        'include_repos' => nil,
      }
    }
  end

  describe '#bark' do
    before do
      expect(ENV).to receive(:[]).once.with('SEAL_ORGANISATION').and_return('navy')
      expect(ENV).to receive(:[]).exactly(number_of_teams).times.with('SLACK_CHANNEL')
      expect(ENV).to receive(:[]).exactly(number_of_teams).times.with('SLACK_WEBHOOK')
      expect(File).to receive(:exist?).at_least(:once).with('./config/navy.yml').and_return(true)
      expect(YAML).to receive(:load_file).and_return(org_config)
      expect(MessageBuilder).to receive(:new)
        .exactly(number_of_teams).times
        .and_return(instance_double(MessageBuilder, build: nil, poster_mood: nil))
      expect(SlackPoster).to receive(:new)
        .exactly(number_of_teams).times
        .and_return(instance_double(SlackPoster, send_request: nil))
    end

    context 'given a team "tigers"' do
      let(:team) { 'tigers' }
      let(:number_of_teams) { 1 }

      it 'fetches PRs for the tigers and only the tigers' do
        expect(GithubFetcher)
          .to receive(:new)
          .with([], nil, nil, nil, nil, nil)
          .and_return(instance_double(GithubFetcher, list_pull_requests: []))

        seal.bark
      end
    end

    context 'given no team' do
      let(:team) { nil }

      context "but two teams, lions and tigers in the organisation's config" do
        let(:number_of_teams) { 2 }

        it 'fetches PRs for the lions and the tigers' do
          expect(GithubFetcher)
            .to receive(:new)
            .with([], nil, nil, nil, nil, nil)
            .and_return(instance_double(GithubFetcher, list_pull_requests: []))

          expect(GithubFetcher)
            .to receive(:new)
            .with([], nil, nil, nil, nil, nil)
            .and_return(instance_double(GithubFetcher, list_pull_requests: []))

          seal.bark
        end
      end
    end
  end
end
