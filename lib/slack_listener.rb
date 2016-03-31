require 'slack-ruby-bot'
require './lib/seal.rb'

module SlackBot
  class SlackListener < SlackRubyBot::Bot
    match /:pr:/ do |client, data, match|
      Seal.new('Developers').update(channel: data.channel)
    end
  end
end
