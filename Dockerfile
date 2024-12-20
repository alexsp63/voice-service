# use a specific Ruby version as a parent image
FROM ruby:2.5.8-alpine

# env vars
ENV APP_PATH /my-voice-service
ENV BUNDLE_VERSION 2.2.23
ENV RAILS_PORT 3001

# set the working directory
WORKDIR $APP_PATH

# install dependencies for application
RUN apk -U add --no-cache \
    build-base \
    git \
    postgresql-dev \
    postgresql-client \
    libxml2-dev \
    libxslt-dev \
    nodejs \
    yarn \
    imagemagick \
    tzdata \
    less \
    && rm -rf /var/cache/apk/*
# install bundler version that was specified in Gemfile.lock
RUN gem install bundler --version $BUNDLE_VERSION \
    && rm -rf $GEM_HOME/cache/*
# create application directory
RUN mkdir -p $APP_PATH 
# copy the current directory into container
ADD . $APP_PATH

# copy Gemfile and Gemfile.lock to the container
COPY Gemfile Gemfile.lock ./

# install dependencies
RUN bundle install

# create file with data from ENV
COPY config/database.yml.sample config/database.yml
COPY .env.sample .env

# remove pre-existing puma/passenger server.pid
RUN rm -rf "${APP_PATH}"/tmp/pids/server.pid

# start server
CMD bundle exec rails server -b 0.0.0.0 -p "${RAILS_PORT}"

EXPOSE $RAILS_PORT
