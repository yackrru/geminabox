FROM ruby:3.0.1-alpine

LABEL maintainer="ttksm <ttksm.git@gmail.com>"

USER root

RUN apk update && \
    apk upgrade && \
    apk add --no-cache \
    build-base \
    && mkdir /app \
    && gem update --system \
    && gem install bundler

WORKDIR /app
COPY Gemfile* config.ru ./
RUN bundle install

ENV BASIC_USER="" \
    BASIC_PASS=""

EXPOSE 9292

ENTRYPOINT ["rackup", "-s", "puma", "--host", "0.0.0.0"]
