require 'spec_helper'
require './lib/message_builder'

describe MessageBuilder do
  let(:pull_requests)   { {"[review but do not merge]Rename Topic to PolicyArea in Publisher UI"=>{"title"=>"[review but do not merge]Rename Topic to PolicyArea in Publisher UI", "link"=>"https://github.com/alphagov/whitehall/pull/2249", "author"=>"jackscotti", "repo"=>"whitehall", "comments_count"=>"5"}}}
  let(:message_builder) { MessageBuilder.new(pull_requests) }

  context "build" do
    it "builds the body of the message to be posted on Slack" do
      expect(message_builder.build).to eq("Good morning team! Here are the pull requests that need to be reviewed today:\n\n1) *whitehall* | jackscotti\n<https://github.com/alphagov/whitehall/pull/2249|[review but do not merge]Rename Topic to PolicyArea in Publisher UI> - 5 comments\n\nMerry reviewing!")
    end
  end

end