require 'sinatra'
require './lib/seal'
require './lib/github_fetcher'
require './lib/message_builder'
require './lib/slack_poster'

# POST /teams/core-formats
post '/teams/?:team_name?' do
  Seal.new(params[:team_name]).bark
end
