require 'slack-poster'

class SlackPoster

  attr_accessor :webhook_url, :poster, :mood, :mood_hash, :channel

  def initialize(webhook_url, team_channel, mood)
    @webhook_url = webhook_url
    @team_channel = team_channel
    @mood = mood
    mood_hash
    channel
    create_poster
  end

  def create_poster
    @poster = Slack::Poster.new("#{webhook_url}", options = {
      icon_emoji: @mood_hash[:icon_emoji],
      username: @mood_hash[:username],
      channel: @team_channel
    })
  end

  def send_request(message)
    poster.send_message("#{message}") unless Date.today.saturday? || Date.today.sunday?
  end

  private

  def mood_hash
    @mood_hash = []
    if @mood == "Informative"
      # @mood_hash[:icon_emoji]= ":send_request:"
      mood_hash[:username]= "Informative Seal"
    elsif @mood == "Angry"
      puts "yeay"
    else
      raise "bad mood"
    end
  end

  def channel
    @team_channel = '#angry-seal-bot-test' if ENV["DYNO"].nil?
  end
end
