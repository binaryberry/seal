# Use this file to easily define all of your cron jobs.
require "tzinfo"

def local(time)
  TZInfo::Timezone.get('America/New_York').local_to_utc(Time.parse(time)).strftime('%H:%M%p')
end

set :output, "/var/log/cron.log"

ENV.each { |k, v| env(k, v) }

job_type :aptible_script, 'cd /lib && set -a && . .aptible.env && :task'

every :day, :at => local('9:00 pm') do
  aptible_script "ruby ./bin/seal.rb"
end

# every 1.minute do
  # aptible_script "ruby ./bin/seal.rb Developers"
# end
