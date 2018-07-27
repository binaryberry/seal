class Team
  def initialize(
                  members: nil,
                  use_labels: nil,
                  compact: nil,
                  exclude_labels: nil,
                  exclude_titles: nil,
                  exclude_repos: nil,
                  include_repos: nil,
                  quotes: nil,
                  slack_channel: nil
                )
    @members = members || []
    @use_labels = (use_labels.nil? ? false : use_labels)
    @compact = (compact.nil? ? false : compact)
    @exclude_labels = exclude_labels || []
    @exclude_titles = exclude_titles || []
    @exclude_repos = exclude_repos || []
    @include_repos = include_repos || []
    @quotes = quotes || []
    @channel = slack_channel
  end

  attr_reader *%i[
    members
    use_labels
    compact
    exclude_labels
    exclude_titles
    exclude_repos
    include_repos
    quotes
    channel
  ]
end
