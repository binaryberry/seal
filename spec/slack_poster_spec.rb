require 'spec_helper'
require './lib/slack_poster'

describe 'slack_poster' do
  subject(:slack_poster) { SlackPoster.new(webhook_url, team_channel, mood) }

  let(:webhook_url) { 'https://slack/webhook' }
  let(:team_channel) { '#angry-seal-bot-test' }
  let(:message) { 'test running!' }
  let(:mood) { 'informative' }
  let(:fake_slack_poster) { instance_double(Slack::Poster) }
  let(:fake_slack_response) { instance_double(Faraday::Response) }

  context 'send_request' do
    let(:slack_response) { true }
    before do
      expect(Slack::Poster).to receive(:new).and_return(fake_slack_poster)
      Timecop.freeze(Time.local(2015, 07, 16))
      allow(fake_slack_response).to receive(:success?).and_return(slack_response)
      allow(fake_slack_poster).to receive(:send_message).with(message).and_return(fake_slack_response)
    end

    context 'successful response' do
      it 'posts to Slack' do
        expect(fake_slack_poster).to receive(:send_message).with(message).and_return(fake_slack_response)
        expect(slack_poster.send_request(message)).to be nil
      end
    end

    context 'failed response' do
      let(:slack_response) { false }
      before do
        allow(fake_slack_response).to receive(:status).and_return(403)
        allow(fake_slack_response).to receive(:reason_phrase).and_return("Forbidden")
        allow(fake_slack_response).to receive(:body).and_return("")
      end

      it 'raises an exception' do
        expect { slack_poster.send_request(message) }.to raise_error(SlackPoster::SlackResponseError)
      end
    end
  end

  context 'create_poster' do
    context 'on a regular day' do
      before do
        expect(Slack::Poster).to receive(:new).and_return(fake_slack_poster)
        Timecop.freeze(Time.local(2015, 07, 16))
      end

      it "posts as Informative Seal" do
        slack_poster.send(:mood_hash)
        expect(slack_poster.send(:mood_hash)).to eq "Informative Seal"
      end
    end

    context 'within a week of Halloween' do
      before do
        expect(Slack::Poster).to receive(:new).and_return(fake_slack_poster)
        Timecop.freeze(Time.local(2015, 10, 28))
      end

      it "knows it is Halloween season" do
        expect(slack_poster.send(:halloween_season?)).to eq true
      end

      it "posts as Halloween Informative Seal" do
        slack_poster.send(:mood_hash)
        expect(slack_poster.send(:mood_hash)).to eq "Halloween Informative Seal"
      end
    end

    context 'within a month of Festive Season' do
      before do
        expect(Slack::Poster).to receive(:new).and_return(fake_slack_poster)
        Timecop.freeze(Time.local(2015, 12, 01))
      end

      it "knows it is Festive Season" do
        expect(slack_poster.send(:festive_season?)).to eq true
      end

      it "posts as Festive Season Informative Seal" do
        slack_poster.send(:mood_hash)
        expect(slack_poster.send(:mood_hash)).to eq "Festive Season Informative Seal"
      end
    end
  end

  context 'bad mood' do
    let(:mood) { 'baadf00d' }

    it 'emits a meaningful error' do
      expect { slack_poster }.to raise_error(RuntimeError, /Bad mood: baadf00d/)
    end
  end
end
