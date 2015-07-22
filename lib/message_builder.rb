class MessageBuilder

  attr_accessor :pull_requests, :report, :mood

  def initialize(pull_requests, mood)
    @pull_requests = pull_requests
    @mood = mood
  end

  def build
    case mood
    when 'informative'
      informative
    when 'angry'
      angry
    else
      fail("This seal does not understand '#{mood}']")
    end
  end

  def rotten?(pull_request)
    age_in_days(pull_request) > 2
  end

  private

  def old_pull_requests
    @old_pull_requests ||= @pull_requests.reject { |title, pr| !rotten?(pr) }
  end

  def bark_about_old_pull_requests
    msg = old_pull_requests.keys.each_with_index.map { |title, n| present(title, n + 1) }
    "AAAAAAARGH! #{these(old_pull_requests.length)} #{pr_plural(old_pull_requests.length)} not been updated in over 2 days.\n\n#{msg.join}\n\n Remember each time you time you forget to review your pull requests, a baby seal dies."
  end

  def list_pull_requests
  @report = "Good morning team! \n\n Here are the pull requests that need to be reviewed today:\n\n"
    n = 0
    @pull_requests.each_key do |pull_request|
      n += 1
      @report = @report + present(pull_request, n)
    end
  @report = @report + "\nMerry reviewing!"
  end

  def no_pull_requests
    "Good morning team! It's a beautiful day! :happyseal: :happyseal: :happyseal:\n\nNo pull requests to review today! :rainbow: :sunny: :metal: :tada:"
  end

  def comments(pull_request)
    return " comment" if @pull_requests[pull_request]["comments_count"] == "1"
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
    pr = pull_requests[pull_request]
    days = age_in_days(pr)
    <<-EOF.gsub(/^\s+/, '')
    #{index}\) *#{pr["repo"]}* | #{pr["author"]} (#{days} #{days_plural(days)} ago)
    <#{pr["link"]}|#{pr["title"]}> - #{pr["comments_count"]}#{comments(pull_request)}
    EOF
  end

  def age_in_days(pull_request)
    (Date.today - pull_request['updated']).to_i
  end

  def days_plural(days)
    if days == 1
      'day'
    else
      'days'
    end
  end

  def informative
   if @pull_requests == {}
      no_pull_requests
    else
      list_pull_requests
      @report
    end
  end

  def angry
    if old_pull_requests.empty?
      ''
    else
      bark_about_old_pull_requests
    end
  end

end
