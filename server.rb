require 'sinatra'
require './lib/seal'
require './lib/github_fetcher'
require './lib/message_builder'
require './lib/slack_poster'
require './lib/team_builder'

class SealApp < Sinatra::Base

  get '/' do
    "Hello Seal"
  end

  post '/bark/:team_name/:secret' do
    if params[:secret] == ENV["SEAL_SECRET"]
      team = TeamBuilder.build(env: ENV, team_name: params[:team_name])
      Seal.new(team).bark
      "Seal received message with #{params[:team_name]} team name"
    end
  end

  post '/bark-quotes/:team_name' do
    team = TeamBuilder.build(env: ENV, team_name: params[:team_name])
    Seal.new(team).bark(mode: 'quotes')
    "Seal received message with #{params[:team_name]} team name for quotes"
  end
end
