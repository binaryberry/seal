require 'spec_helper'
require './lib/message_builder'

describe MessageBuilder do
	let(:pull_requests) 	{ {"Use gds-ruby-styleguide to provide Rubocop"=>{"title"=>"Use gds-ruby-styleguide to provide Rubocop", "link"=>"https://github.com/alphagov/whitehall/pull/2228", "repo"=>"whitehall"}, "Added Doctor Who as Minister of Education"=>{"title"=>"Added Doctor Who as Minister of Education", "link"=>"https://github.com/alphagov/whitehall/pull/2227", "repo"=>"frontend"}}}
	let(:message_builder) { MessageBuilder.new(pull_requests) }

	context "build" do
		it "builds the body of the message to be posted on Slack" do
			expect(message_builder.build).to eq('Good morning team! Here are the pull requests that need to be reviewed today:
whitehall | <https://github.com/alphagov/whitehall/pull/2228|Use gds-ruby-styleguide to provide Rubocop>
frontend | <https://github.com/alphagov/whitehall/pull/2227|Added Doctor Who as Minister of Education>
Merry reviewing!')
		end
	end

end