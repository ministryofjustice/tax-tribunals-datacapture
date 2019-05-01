FROM ruby:2.5.3

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN bundle install

COPY . /usr/src/app

RUN touch /etc/inittab

ENV DATACAPTURE_URI https://tax-tribunals-datacapture-dev.dsd.io

RUN apt-get update && apt-get install -y && apt-get install libcurl4-gnutls-dev -y

CMD bundle exec cucumber
