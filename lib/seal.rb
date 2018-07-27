#!/usr/bin/env ruby

require "message_builder"
require "slack_poster"

# Entry point for the Seal!
class Seal
  def initialize(teams)
    @teams = teams
  end

  def bark(mode: nil)
    teams.each do |team|
      bark_at(team, mode: mode)
    end
  end

  private

  attr_reader :teams

  def bark_at(team, mode: nil)
    message = case mode
    when "quotes"
      Message.new(team.quotes.sample)
    else
      MessageBuilder.new(team).build
    end

    poster = SlackPoster.new(team.channel, message.mood)
    poster.send_request(message.text)
  end
end
