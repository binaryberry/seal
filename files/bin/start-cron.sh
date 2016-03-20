#!/bin/sh
# start-cron.sh

rsyslogd
cron
touch /var/log/cron.log
tail -F /var/log/syslog /var/log/cron.log
