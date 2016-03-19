FROM quay.io/aptible/ruby:2.2

RUN apt-get update && apt-get -y install build-essential

RUN apt-get update && apt-get -y install libpq-dev

COPY . /lib
WORKDIR /lib
RUN bundle install
ADD . /lib

ENV PORT 4567
EXPOSE 4567
