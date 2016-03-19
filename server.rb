require 'sinatra'
require './lib/seal'
require './lib/github_fetcher'
require './lib/message_builder'
require './lib/slack_poster'

class SealApp < Sinatra::Base

  set :port, 4567

  get '/' do
    "Hello Seal"
  end
  # POST /teams/core-formats

  post '/teams/?:team_name?' do
    Seal.new(params[:team_name]).bark
  end

end
