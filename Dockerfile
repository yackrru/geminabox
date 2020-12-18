FROM ruby:2.7-alpine AS Builder

RUN apk add --no-cache build-base
RUN gem install bundler

WORKDIR /app
ADD Gemfile* ./
RUN bundle install


FROM ruby:2.7-alpine
LABEL maintainer="Zac"

WORKDIR /app
COPY --from=Builder /usr/local/bundle/ /usr/local/bundle/
COPY Gemfile* config.ru ./

ENV BASIC_USER=""
ENV BASIC_PASS=""
ENV RACK_ENV="production"

EXPOSE 9292

ENTRYPOINT ["bundle", "exec", "puma"]
