FROM quay.io/aptible/ruby:2.2

RUN apt-get update && \ 
  apt-get -y install build-essential && \
  apt-get update && \
  apt-get -y install libpq-dev && \
  apt-get -y install rsyslog

COPY . /lib
WORKDIR /lib
RUN bundle install
ADD files/etc/crontab /etc/crontab
ADD files/bin/start-cron.sh /usr/bin/start-cron.sh
RUN chmod +x /usr/bin/start-cron.sh
RUN touch /var/log/cron.log
ADD . /lib

ENV PORT 4567
EXPOSE 4567
