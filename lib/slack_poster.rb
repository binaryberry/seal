require 'slack-poster'

class SlackPoster


	attr_accessor :webhook_url, :poster

	def initialize(webhook_url)
		@poster = Slack::Poster.new("#{webhook_url}", options = {
  		icon_emoji: ':informative_seal:',
  		username: 'Informative Seal',
  		channel: '#core-formats'
		})
		@webhook_url = webhook_url
	end

	def send_request(message)
		poster.send_message("#{message}")
	end

end