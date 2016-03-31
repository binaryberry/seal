FROM quay.io/aptible/ruby:2.2

RUN apt-get update && \ 
  apt-get -y install build-essential && \
  apt-get update && \
  apt-get -y install libpq-dev && \
  apt-get -y install rsyslog && \
  apt-get update && apt-get -y install cron

COPY . /lib
WORKDIR /lib
RUN bundle install
RUN touch /var/log/cron.log && chmod go+rw /var/log/cron.log
ADD . /lib

ENV PORT 9292
EXPOSE 9292
