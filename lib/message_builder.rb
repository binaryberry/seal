class MessageBuilder

	attr_accessor :pull_requests, :list

	def initialize(pull_requests)
		@pull_requests = pull_requests
		list_pull_requests
	end

	def build
		intro.concat(list_pull_requests	)

	end

	private

	def intro
		"Good morning team! Here are the pull requests that need to be reviewed today:"
	end

	def list_pull_requests
		@list = ""
		@pull_requests.each do |pull_request, link|
			@list = @list.concat("#{link} | #{pull_request}>\n")
		end
		@list
	end

end