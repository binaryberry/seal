class MessageBuilder

  attr_accessor :pull_requests, :list

  def initialize(pull_requests)
    @pull_requests = pull_requests
  end

  def build
    if @pull_requests == {}
      no_pull_requests
    else
      list_pull_requests
      intro + @list + conclusion
    end
  end

  private

  def intro
    "Good morning team! \n\n Here are the pull requests that need to be reviewed today:\n\n"
  end

  def list_pull_requests
  @list = ""
    n = 0
    @pull_requests.each_key do |pull_request|
      n += 1
      @list = @list + "#{n}) *" + pull_requests[pull_request]["repo"] + "* | " +
                                  pull_requests[pull_request]["author"] +
                                  "\n<" + pull_requests[pull_request]["link"] + "|" + pull_requests[pull_request]["title"]  + "> - " +
                                  pull_requests[pull_request]["comments_count"] + comments(pull_request) + "\n"
    end
  @list
  end

  def no_pull_requests
    "Good morning team! It's a beautiful day! :happyseal: :happyseal: :happyseal:\n\nNo pull requests to review today! :rainbow: :sunny: :metal: :tada:"
  end

  def conclusion
    "\nMerry reviewing!"
  end

  def comments(pull_request)
    return " comment" if @pull_requests[pull_request]["comments_count"] == "1"
    " comments"
  end
end
