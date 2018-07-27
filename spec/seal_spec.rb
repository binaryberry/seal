require "spec_helper"
require_relative "../lib/seal"

RSpec.describe Seal do
  subject(:seal) { described_class.new(teams) }

  let(:lions) {
    Team.new(
      slack_channel: "#lions",
      quotes: ["go lions!"],
    )
  }
  let(:tigers) {
    Team.new(
      slack_channel: "#tigers",
    )
  }
  let(:teams) do
    [
      lions,
      tigers,
    ]
  end

  let(:slack_poster) { instance_double(SlackPoster, send_request: nil) }
  let(:message_builder) { instance_double(MessageBuilder, build: message) }
  let(:message) { instance_double(Message, mood: "", text: "") }

  describe ".bark(mode: nil)" do
    before do
      allow(SlackPoster).to receive(:new).and_return(slack_poster)
    end

    it "barks at all teams" do
      teams.each do |team|
        expect(MessageBuilder).to receive(:new).with(team).and_return(message_builder)
        expect(SlackPoster).to receive(:new).with(team.channel, anything)
      end

      subject.bark
    end

    context "when in quotes mode" do
      let(:teams) { [lions] }

      it "barks at all teams" do
        expect(Message).to receive(:new).with("go lions!").and_return(message)
        expect(SlackPoster).to receive(:new).with(lions.channel, anything)

        subject.bark(mode: "quotes")
      end
    end
  end
end
