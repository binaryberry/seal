# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

set :output, "/var/log/cron.log"

ENV.each { |k, v| env(k, v) }

job_type :aptible_script, 'cd /lib && set -a && . .aptible.env && :task'

every :day, :at => '5:30pm' do
  aptible_script "ruby ./bin/seal.rb Developers"
end
