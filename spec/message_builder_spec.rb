require 'spec_helper'
require './lib/message_builder'

describe MessageBuilder do
	let(:pull_requests) 	{ {"Remove references to archived" => ["https://github.com/alphagov/whitehall/pull/2219","whitehall"], "Added Doctor Who logo"=>["https://github.com/alphagov/whitehall/pull/2218","frontend"]} }
	let(:message_builder) { MessageBuilder.new(pull_requests) }

	context "build" do
		it "builds the body of the message to be posted on Slack" do
			expect(message_builder.build).to eq('Good morning team! Here are the pull requests that need to be reviewed today:
whitehall | <https://github.com/alphagov/whitehall/pull/2219|Remove references to archived>
frontend | <https://github.com/alphagov/whitehall/pull/2218|Added Doctor Who logo>
Merry reviewing!')
		end
	end

end