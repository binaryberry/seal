#!/usr/bin/env ruby

require "./lib/github_fetcher.rb"
require "./lib/message_builder.rb"
require "./lib/slack_poster.rb"

TEAM_MEMBERS_ACCOUNTS = ["jennyd", "dsingleton", "tommyp", "issyl0", "mikejustdoit", "marksheldonGDS"]
TEAM_REPOS = %w(business-support-api calendars contacts-admin contacts-frontend content-register content-store courts-api courts-frontend hmrc-manuals-api imminence licence-finder manuals-frontend optic14n pre-transition-stats publishing-api side-by-side-browser smart-answers specialist-publisher static trade-tariff-admin trade-tariff-backend trade-tariff-frontend transition transition-config transition-stats url-arbiter whitehall).sort!
TEAM_CHANNEL = "#custom"


git = GithubFetcher.new(TEAM_MEMBERS_ACCOUNTS,TEAM_REPOS)

list = git.list_pull_requests

message_builder = MessageBuilder.new(list)

message = message_builder.build

slack = SlackPoster.new(ENV["SLACK_WEBHOOK"], TEAM_CHANNEL)

slack.send_request(message)
