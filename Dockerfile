FROM ruby:2.6.5

LABEL maintainer="ttksm <ttksm.git@gmail.com>"

USER root

RUN mkdir /app \
    && gem update --system \
    && gem uninstall bundler \
    && gem install bundler -v 2.1.4

WORKDIR /app
COPY Gemfile* config.ru ./
RUN bundle install

ENV BASIC_USER="" \
    BASIC_PASS=""

EXPOSE 9292

ENTRYPOINT ["rackup", "--host", "0.0.0.0"]
