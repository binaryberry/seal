require 'slack-poster'

class SlackPoster

	attr_accessor :webhook_url, :poster

	def initialize(webhook_url, team_channel)
		if ENV["DYNO"].nil?
			@poster = Slack::Poster.new("#{webhook_url}", options = {
	  		icon_emoji: ':informative_seal:',
	  		username: 'Informative Seal',
	  		channel: '#angry-seal-bot-test'
			})
		else
			@poster = Slack::Poster.new("#{webhook_url}", options = {
	  		icon_emoji: ':informative_seal:',
	  		username: 'Informative Seal',
	  		channel: team_channel
			})
		end
			@webhook_url = webhook_url
	end

	def send_request(message)
		poster.send_message("#{message}") unless Date.today.saturday? || Date.today.sunday?
	end

end
