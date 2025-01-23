# use a specific Ruby version as a parent image
FROM ruby:3.2.0-alpine

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
    && rm -rf $GEM_HOME/cache/* \
    && gem install nokogiri -- --use-system-libraries \
    && gem install tzinfo -v "~> 1.2" \
    && gem install tzinfo-data
# create application directory
RUN mkdir -p $APP_PATH 
# copy the current directory into container
ADD . $APP_PATH

# copy Gemfile and Gemfile.lock to the container
COPY Gemfile Gemfile.lock ./

# install dependencies
# RUN bundle config build.nokogiri --use-system-libraries
RUN bundle install

# create file with data from ENV
COPY config/database.yml.sample config/database.yml
COPY .env.sample .env

# remove pre-existing puma/passenger server.pid
RUN rm -rf "${APP_PATH}"/tmp/pids/server.pid

# prepare databases, add data to development DB and start server
CMD is_db_created=$(bundle exec rails db:migrate:status 2>&1) ; \
    echo "Preparing database..." ; \
    if [ -n "${is_db_created##*Status   Migration ID    Migration Name*}" ] ; then \
        echo "Database does not exists. Creating database..." ; \
        SCHEMA=db/schema.rb bundle exec rails db:create db:schema:load; \
        echo "Adding data..." ; \
        bundle exec rails db:seed ; \
    fi ; \
    echo "Database setup is completed" ; \
    is_test_db_created=$(RAILS_ENV=test bundle exec rails db:migrate:status 2>&1) ; \
    echo "Preparing test database..." ; \
    if [ -n "${is_test_db_created##*Status   Migration ID    Migration Name*}" ] ; then \
        echo "Test database does not exists. Creating test database..." ; \
        RAILS_ENV=test SCHEMA=db/schema.rb bundle exec rails db:create db:schema:load; \
    fi ; \
    echo "Test database setup is completed. Starting rails server..." ; \
    bundle exec rails server -b 0.0.0.0 -p "${RAILS_PORT}"

EXPOSE $RAILS_PORT
