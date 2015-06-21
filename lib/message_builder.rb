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
		"Good morning team! Here are the pull requests that need to be reviewed today:\n\n"
	end

	def list_pull_requests
		@list = ""
		n = 0
		@pull_requests.each_key do |pull_request|
			n += 1
			@list = @list + "#{n}) _" + pull_requests[pull_request]["repo"] + " | " + pull_requests[pull_request]["author"] + "_\n<" + pull_requests[pull_request]["link"] + "|" + pull_requests[pull_request]["title"]  + ">\n"
		end
		@list
	end

	def conclusion
		"Merry reviewing!"
	end

end
