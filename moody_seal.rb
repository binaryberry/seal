#!/usr/bin/env ruby

require "./lib/github_fetcher.rb"
require "./lib/message_builder.rb"
require "./lib/slack_poster.rb"

puts "it runs!"

TEAM_MEMBERS_ACCOUNTS = ["binaryberry", "jamiecobbett", "boffbowsh", "alicebartlett", "benilovj", "fofr", "russellthorn", "edds"]
TEAM_REPOS = %w(maslow signonotron2 short-url-manager support feedback frontend specialist-publisher publisher whitehall govuk_content_api release metadata-api travel-advice-publisher info-frontend government-frontend support-api external-link-tracker specialist-frontend static asset-manager content-store url-arbiter content-register).sort!



git = GithubFetcher.new(TEAM_MEMBERS_ACCOUNTS,TEAM_REPOS)

list = git.list_pull_requests

message_builder = MessageBuilder.new(list)

message = message_builder.build

slack = SlackPoster.new(ENV["SLACK_WEBHOOK"])

slack.send_request(message)