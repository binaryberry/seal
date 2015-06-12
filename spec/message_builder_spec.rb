require 'spec_helper'
require './lib/message_builder'

describe MessageBuilder do
	let(:pull_requests) 	{ [{"first pull request" => "www.google.com", "second pull request" => "www.gov.uk"}] }
	let(:message_builder) { MessageBuilder.new(pull_requests) }

	context "build" do
		it "builds the body of the message to be posted on Slack" do
			expect(message_builder.build).to eq('Good morning team! Here are the pull requests that need to be reviewed today: "www.google.com"|"second pull request"')
		end
	end

end