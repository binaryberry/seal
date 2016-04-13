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

  context 'tea notifications are sent on time' do
    before { expect(Slack::Poster).to receive(:new).and_return(fake_slack_poster) }
    let(:mood) { 'tea' }
    let(:team_channel) { '#tea' }

    context 'on Wednesday' do
      let(:wednesday) { Time.local(2016, 4, 13) }
      before { Timecop.freeze(wednesday) }
      it 'is not time for tea' do
        expect(fake_slack_poster).not_to receive(:send_message)
        slack_poster.send_request('earl grey')
      end
    end

    context 'on Friday' do
      let(:friday) { Time.local(2016, 4, 15) }
      before { Timecop.freeze(friday) }
      it 'is tea time' do
        expect(fake_slack_poster).to receive(:send_message).with('earl grey')
        slack_poster.send_request('earl grey')
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
