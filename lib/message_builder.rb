class MessageBuilder

  attr_accessor :pull_requests, :list

  def initialize(pull_requests)
    @pull_requests = pull_requests
  end

  def build
    list_pull_requests
    intro + @list + conclusion

  end

  private

  def intro
    "Good morning team! \n Sorry I was on strike! I'll be back to posting at 9.30am from next week.\n In the meantime, here are the pull requests that need to be reviewed today:\n\n"
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

  def conclusion
    "\nMerry reviewing!"
  end

  def comments(pull_request)
    return " comment" if @pull_requests[pull_request]["comments_count"] == "1"
    " comments"
  end
end
