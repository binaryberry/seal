#!/usr/bin/env ruby

require "./lib/github_fetcher.rb"
require "./lib/message_builder.rb"
require "./lib/slack_poster.rb"

TEAM_MEMBERS_ACCOUNTS = %w(alext alextea bishboria KushalP markhurrell rboulton tijmenb)
TEAM_REPOS = ["static", "slimmer", "panopticon", "frontend", "whitehall", "smart-answers", "rummager", "smokey", "design-principles", "signonotron2", "prototyping", "govuk_content_models", "trade-tariff-backend", "styleguides", "e-petitions", "govuk_content_api", "business-support-finder", "govuk_frontend_toolkit", "support", "fabric-scripts", "assets-directgov", "government-service-design-manual", "transition-config", "release", "Accessible-Media-Player", "gds-boxen", "govuk_frontend_toolkit_gem", "trade-tariff-admin", "packager", "transition-stats", "ci-puppet", "transformation-dashboard", "govuk_template", "govuk_mirror-puppet", "fourth-wall", "maslow", "router", "govuk_frontend_toolkit_npm", "finder-frontend", "specialist-publisher", "backdrop-transactions-explorer-collector", "search-performance-dashboard", "govuk_elements", "govuk_migration_plan_public", "collections", "search-admin", "cdn-acceptance-tests", "smartdown", "support-api", "govuk_prototype_kit", "collections-publisher", "gradle-gatling-plugin", "metadata-api", "email-alert-api", "cloudflare-configure", "govuk-content-schemas", "email-alert-monitor", "policy-publisher", "govdelivery-email-templates", "ier-frontend", "govuk-content-schema-test-helpers", "interaction-diagrams", "tsuru-ansible", "tsuru-terraform", "payment-prototype-options", "digitalmarketplace-utils", "govuk-content-best-practices", "multicloud-deploy", "ansible-role-openconnect", "ansible-playbook-docker_server", "ansible-playbook-gandalf", "ansible-playbook-hipache", "ansible-playbook-tsuru_api", "ansible-playbook-redis", "terraform", "github_sshkey_checker", "authenticating-proxy", "puppet-rcs", "puppet-autofsck", "tsuru-dashboard", "govuk-rails-app-template", "ansible-statsd", "ansible-graphite", "tsuru-testing", "document-kit", "example-java-jetty", "govuk-lint", "situation-room", "situation-room-dashboard"].sort!
TEAM_CHANNEL = "#finding-things"


git = GithubFetcher.new(TEAM_MEMBERS_ACCOUNTS,TEAM_REPOS)

list = git.list_pull_requests

message_builder = MessageBuilder.new(list)

message = message_builder.build

slack = SlackPoster.new(ENV["SLACK_WEBHOOK"], TEAM_CHANNEL, "Informative")

slack.send_request(message)
