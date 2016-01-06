require 'slack-poster'

class SlackPoster

  attr_accessor :webhook_url, :poster, :mood, :mood_hash, :channel, :season_name, :halloween_season, :festive_season

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
    @mood_hash = {}
    check_season
    check_if_quotes
    assign_poster_settings
  end

  def assign_poster_settings
    if @mood == "informative"
      @mood_hash[:icon_emoji]= ":#{@season_symbol}informative_seal:"
      @mood_hash[:username]= "#{@season_name}Informative Seal"
    elsif @mood == "approval"
      @mood_hash[:icon_emoji]= ":#{@season_symbol}seal_of_approval:"
      @mood_hash[:username]= "#{@season_name}Seal of Approval"
    elsif @mood == "angry"
      @mood_hash[:icon_emoji]= ":#{@season_symbol}angrier_seal:"
      @mood_hash[:username]= "#{@season_name}Angry Seal"
    elsif @mood == "tea" && @postable_day
      @mood_hash[:icon_emoji]= ":manatea:"
      @mood_hash[:username]= "Tea Seal"
    elsif @mood == "charter" && @postable_day
      @mood_hash[:icon_emoji]= ":happyseal:"
      @mood_hash[:username]= "Core Team Charter Seal"
    else
      raise "bad mood"
    end
  end

  def check_season
    if halloween_season?
      @season_name = "Halloween "
    elsif festive_season?
      @season_name = "Festive Season "
    else
      @season_name = ""
    end
    @season_symbol = snake_case(@season_name)
  end

  def halloween_season?
    this_year = Date.today.year
    Date.today <= Date.new(this_year, 10, 31) && Date.today >= Date.new(this_year,10,23)
  end

  def festive_season?
    this_year = Date.today.year
    return true if Date.today <= Date.new(this_year, 12, 31) && Date.today >= Date.new(this_year,12,1)
    Date.today == Date.new(this_year, 01, 01)
  end

  def snake_case(string)
    string.downcase.gsub(" ", "_")
  end

  def check_if_quotes
    today = Date.today
    if @team_channel == "#tea"
      @mood = "tea"
      @postable_day = today.friday?
    elsif @mood == nil && @team_channel == "#core-formats"
      @mood = "charter"
      @postable_day = today.tuesday? || today.thursday?
    end
  end

  def channel
    @team_channel = '#angry-seal-bot-test' if ENV["DYNO"].nil?
  end
end
