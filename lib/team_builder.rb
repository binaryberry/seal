require_relative "team"

class TeamBuilder
  def self.build(env: {}, team_name: nil)
    self.new(env).build(team_name)
  end

  def initialize(env)
    @env = env
  end

  def build(team_name = nil)
    if team_name && !team_name.empty?
      build_single_team(team_name)
    else
      build_all_teams
    end
  end

  private

  attr_reader :env

  def build_single_team(team_name)
    [
      Team.new(apply_env(static_config[team_name.to_sym])),
    ]
  end

  def build_all_teams
    static_config.map do |_, team_config|
      Team.new(apply_env(team_config))
    end
  end

  def apply_env(config)
    {
      members: env["GITHUB_MEMBERS"]&.split(",") || config[:members],
      use_labels: env["GITHUB_USE_LABELS"] == "true" || config[:use_labels],
      exclude_labels: env["GITHUB_EXCLUDE_LABELS"]&.split(',') || config[:exclude_labels],
      exclude_titles: env["GITHUB_EXCLUDE_TITLES"]&.split(',') || config[:exclude_titles],
      exclude_repos: env["GITHUB_EXCLUDE_REPOS"]&.split(',') || config[:exclude_repos],
      include_repos: env["GITHUB_INCLUDE_REPOS"]&.split(',') || config[:include_repos],
      quotes: env["SEAL_QUOTES"]&.split(',') || config[:quotes],
      slack_channel: env["SLACK_CHANNEL"] || config[:channel],
    }
  end

  def static_config
    @static_config ||= begin
      filename = File.join(File.dirname(__FILE__), "../config/#{env['SEAL_ORGANISATION']}.yml")

      if File.exist?(filename)
        YAML.load_file(filename)
      else
        {}
      end
    end
  end
end
