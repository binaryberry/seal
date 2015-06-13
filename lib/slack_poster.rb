require 'slack-poster'

class SlackPoster


	attr_accessor :github_response, :webhook_url, :poster

	def initialize(webhook_url)
		@poster = Slack::Poster.new("#{webhook_url}")
		@github_response = github_response
		@webhook_url = webhook_url
	end

	def send_request(message)
		poster.send_message("#{message}")
	end

end