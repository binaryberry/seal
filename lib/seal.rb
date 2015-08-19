#!/usr/bin/env ruby

require 'yaml'

require './lib/github_fetcher.rb'
require './lib/message_builder.rb'
require './lib/slack_poster.rb'

# Entry point for the Seal!
class Seal
  ORGANISATION ||= ENV['SEAL_ORGANISATION']

  def initialize(team, mood)
    @team = team
    @mood = mood
  end

  def bark
    teams.each { |team| bark_at(team) }
  end

  private

  attr_accessor :mood

  def teams
    if @team.nil?
      org_config.keys
    else
      [@team]
    end
  end

  def bark_at(team)
    message_builder = MessageBuilder.new(pull_requests(team), mood)
    message = message_builder.build
    slack = SlackPoster.new(ENV['SLACK_WEBHOOK'], team_config(team)['channel'], message_builder.poster_mood)
    slack.send_request(message)
  end

  def org_config
    @org_config ||= YAML.load_file("./config/#{ORGANISATION}.yml")
  end

  def pull_requests(team)
    config = team_config(team)
    git = GithubFetcher.new(config['members'],
                            config['repos'],
                            config['use_labels'],
                            config['exclude_labels'],
                            config['exclude_titles']
                           )
    git.list_pull_requests
  end

  def team_config(team)
    org_config[team]
  end
end
