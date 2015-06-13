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
		"Good morning team! Here are the pull requests that need to be reviewed today:\n"
	end

	def list_pull_requests
		@list = ""


		@pull_requests.each_key do |pull_request|
			@list = @list + pull_requests[pull_request][1] + " | <" + pull_requests[pull_request][0] + "|" + pull_request + ">\n"
		end
		@list
	end

	def conclusion
		"Merry reviewing!"
	end

end