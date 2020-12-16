FROM ruby:2.6.6-alpine

LABEL maintainer="ttksm <ttksm.git@gmail.com>"

USER root

RUN mkdir /app \
    && gem update --system \
    && gem install bundler

WORKDIR /app
COPY Gemfile* config.ru ./
RUN bundle install

ENV BASIC_USER="" \
    BASIC_PASS=""

EXPOSE 9292

ENTRYPOINT ["rackup", "--host", "0.0.0.0"]
