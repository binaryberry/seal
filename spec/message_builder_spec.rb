require 'spec_helper'
require './lib/message_builder'

describe MessageBuilder do
  let(:pull_requests)   { {"[review but do not merge]Rename Topic to PolicyArea in Publisher UI"=>{"title"=>"[review but do not merge]Rename Topic to PolicyArea in Publisher UI", "link"=>"https://github.com/alphagov/whitehall/pull/2249", "author"=>"jackscotti", "repo"=>"whitehall", "comments_count"=>"1"}}}
  let(:empty_pull_request) {{}}

  context "build" do
    it "builds the body of the message to be posted on Slack" do
      message_builder = MessageBuilder.new(pull_requests)
      expect(message_builder.build).to eq("Good morning team! \n\n Here are the pull requests that need to be reviewed today:\n\n1) *whitehall* | jackscotti\n<https://github.com/alphagov/whitehall/pull/2249|[review but do not merge]Rename Topic to PolicyArea in Publisher UI> - 1 comment\n\nMerry reviewing!")
    end

    it "displays a happy message when there are no pull requests" do
      message_builder = MessageBuilder.new(empty_pull_request)
      expect(message_builder.build).to eq("Good morning team! It's a beautiful day! :happyseal: :happyseal: :happyseal:\n\nNo pull requests to review today! :rainbow: :sunny: :metal: :tada:")
    end
  end

end