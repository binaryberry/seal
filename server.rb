require 'sinatra'
require './lib/seal'
require './lib/github_fetcher'
require './lib/message_builder'
require './lib/slack_poster'

class SealApp < Sinatra::Base

  get '/' do
    "Hello Seal"
  end

  post '/bark/:team_name/:secret' do
    if params[:secret] == ENV["SEAL_SECRET"]
      Thread.start do
        Seal.new(params[:team_name]).bark
      end
      "Just a second..."
    end
  end

  post '/bark-quotes/:team_name' do
    Seal.new(params[:team_name], "quotes").bark
    "Seal received message with #{params[:team_name]} team name"
  end
end
