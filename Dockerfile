FROM ruby:2.3-slim-jessie

ENV APP_PATH /src/magnifier

RUN groupadd -r vets-api && \
useradd -r -g vets-api vets-api && \
apt-get update -qq && \
apt-get install -y build-essential \
git \
libpq-dev \
clamav \
imagemagick \
pdftk \
poppler-utils

WORKDIR $APP_PATH
ADD Gemfile $APP_PATH
ADD Gemfile.lock $APP_PATH
ADD . /src/magnifier

RUN bundle install
