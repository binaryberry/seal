require 'sinatra'
require './lib/seal'
require './lib/github_fetcher'
require './lib/message_builder'
require './lib/slack_poster'

get '/seal' do
  Seal.new("core-formats").bark
end