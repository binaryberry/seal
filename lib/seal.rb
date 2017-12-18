#!/usr/bin/env ruby

require 'yaml'

require './lib/github_fetcher.rb'
require './lib/message_builder.rb'
require './lib/slack_poster.rb'

# Entry point for the Seal!
class Seal

  attr_reader :mode

  def initialize(team, mode=nil)
    @team = team
    @mode = mode
  end

  def bark
    teams.each { |team| bark_at(team) }
  end

  private

  attr_accessor :mood

  def teams
    if @team.nil? && org_config
      org_config.keys
    else
      [@team]
    end
  end

  def bark_at(team)
    message_builder = MessageBuilder.new(team_params(team), @mode)
    message = message_builder.build
    channel = ENV["SLACK_CHANNEL"] ? ENV["SLACK_CHANNEL"] : team_config(team)['channel']
    slack = SlackPoster.new(ENV['SLACK_WEBHOOK'], channel, message_builder.poster_mood)
    slack.send_request(message)
  end

  def org_config
    @org_config ||= YAML.load_file(configuration_filename) if File.exist?(configuration_filename)
  end

  def configuration_filename
    @configuration_filename ||= "./config/#{ENV['SEAL_ORGANISATION']}.yml"
  end

  def team_params(team)
    config = team_config(team)
    if config
      members = config['members']
      use_labels = config['use_labels']
      exclude_labels = config['exclude_labels']
      exclude_titles = config['exclude_titles']
      exclude_repos = config['exclude_repos']
      include_repos = config['include_repos']
      @quotes = config['quotes']
    else
      members = ENV['GITHUB_MEMBERS'] ? ENV['GITHUB_MEMBERS'].split(',') : []
      use_labels = ENV['GITHUB_USE_LABELS'] ? ENV['GITHUB_USE_LABELS'].split(',') : nil
      exclude_labels = ENV['GITHUB_EXCLUDE_LABELS'] ? ENV['GITHUB_EXCLUDE_LABELS'].split(',') : nil
      exclude_titles = ENV['GITHUB_EXCLUDE_TITLES'] ? ENV['GITHUB_EXCLUDE_TITLES'].split(',') : nil
      exclude_repos = ENV['GITHUB_EXCLUDE_REPOS'] ? ENV['GITHUB_EXCLUDE_REPOS'].split(',') : nil
      include_repos = ENV['GITHUB_INCLUDE_REPOS'] ? ENV['GITHUB_INCLUDE_REPOS'].split(',') : nil
      @quotes = ENV['SEAL_QUOTES'] ? ENV['SEAL_QUOTES'].split(',') : nil
    end
    return fetch_from_github(members, use_labels, exclude_labels, exclude_titles, exclude_repos, include_repos) if @mode == nil
    @quotes
  end


  def fetch_from_github(members, use_labels, exclude_labels, exclude_titles, exclude_repos, include_repos)
    git = GithubFetcher.new(members,
                            use_labels,
                            exclude_labels,
                            exclude_titles,
                            exclude_repos,
                            include_repos
                           )
    git.list_pull_requests
  end

  def team_config(team)
    org_config[team] if org_config
  end
end
