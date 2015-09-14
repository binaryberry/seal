require 'spec_helper'
require './lib/slack_poster'

describe 'slack_poster' do
  subject(:slack_poster) { SlackPoster.new(webhook_url, team_channel, mood) }

  let(:webhook_url) { 'https://slack/webhook' }
  let(:team_channel) { '#angry-seal-bot-test' }
  let(:message) { 'test running!' }
  let(:mood) { 'informative' }
  let(:fake_slack_poster) { instance_double(Slack::Poster) }

  context 'send_request' do
    before do
      expect(Slack::Poster).to receive(:new).and_return(fake_slack_poster)
      Timecop.freeze(Time.local(2015, 07, 16))
    end

    it 'posts to Slack' do
      expect(fake_slack_poster).to receive(:send_message).with(message).and_return(:ok)
      expect(slack_poster.send_request(message)).to be :ok
    end
  end
end
