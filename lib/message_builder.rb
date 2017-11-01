class MessageBuilder

  attr_accessor :pull_requests, :report, :mood, :poster_mood

  def initialize(content, mode=nil)
    @content = content
    @mode = mode
  end

  def build
    if @mode == "quotes"
      bark_about_quotes
    else
      github_seal
    end
  end

  def github_seal
    if !old_pull_requests.empty?
      @poster_mood = "angry"
      bark_about_old_pull_requests
    elsif @content.empty?
      @poster_mood = "approval"
      no_pull_requests
    else
      @poster_mood = "informative"
      list_pull_requests
    end
  end

  def rotten?(pull_request)
    today = Date.today
    actual_age = (today - pull_request['updated']).to_i
    if today.monday?
      weekdays_age = actual_age - 2
    elsif today.tuesday?
      weekdays_age = actual_age - 1
    else
      weekdays_age = actual_age
    end
    weekdays_age > 2
  end

  private

  def old_pull_requests
    @old_pull_requests ||= @content.select { |_title, pr| rotten?(pr) }
  end

  def bark_about_old_pull_requests
    angry_bark = old_pull_requests.keys.each_with_index.map { |title, n| present(title, n + 1) }
    recent_pull_requests = @content.reject { |_title, pr| rotten?(pr) }
    list_recent_pull_requests = recent_pull_requests.keys.each_with_index.map { |title, n| present(title, n + 1) }
    informative_bark = "There are also these pull requests that need to be reviewed today:\n\n#{list_recent_pull_requests.join} " if !recent_pull_requests.empty?
    "AAAAAAARGH! #{these(old_pull_requests.length)} #{pr_plural(old_pull_requests.length)} not been updated in over 2 days.\n\n#{angry_bark.join}\nRemember each time you forget to review your pull requests, a baby seal dies.
    \n\n#{informative_bark}"
  end

  def list_pull_requests
    message = @content.keys.each_with_index.map { |title, n| present(title, n + 1) }
    "Hello team! \n\n Here are the pull requests that need to be reviewed today:\n\n#{message.join}\nMerry reviewing!"
  end

  def no_pull_requests
    "Aloha team! It's a beautiful day! :happyseal: :happyseal: :happyseal:\n\nNo pull requests to review today! :rainbow: :sunny: :metal: :tada:"
  end

  def bark_about_quotes
    @content.sample
  end

  def comments(pull_request)
    return " comment" if @content[pull_request]["comments_count"] == "1"
    " comments"
  end

  def these(items)
    if items == 1
      'This'
    else
      'These'
    end
  end

  def pr_plural(prs)
    if prs == 1
      'pull request has'
    else
      'pull requests have'
    end
  end

  def present(pull_request, index)
    pr = @content[pull_request]
    days = age_in_days(pr)
    thumbs_up = ''
    thumbs_up = " | #{pr["thumbs_up"].to_i} :+1:" if pr["thumbs_up"].to_i > 0
    approved = pr["approved"] ? " | :white_check_mark: " : ""
    <<-EOF.gsub(/^\s+/, '')
    #{index}\) *#{pr["repo"]}* | #{pr["author"]} | updated #{days_plural(days)}#{thumbs_up}#{approved}
    #{labels(pr)} <#{pr["link"]}|#{html_encode(pr["title"])}> - #{pr["comments_count"]}#{comments(pull_request)}
    EOF
  end

  def age_in_days(pull_request)
    (Date.today - pull_request['updated']).to_i
  end

  def days_plural(days)
    case days
    when 0
      'today'
    when 1
      "yesterday"
    else
      "#{days} days ago"
    end
  end

  def labels(pull_request)
    pull_request['labels']
      .map { |label| "[#{label['name']}]" }
      .join(' ')
  end

  def html_encode(string)
    string.tr('&', '&amp;').tr('<', '&lt;').tr('>', '&gt;')
  end
end
