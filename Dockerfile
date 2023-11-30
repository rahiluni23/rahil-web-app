# Use the official Ruby 2.7.0 image
FROM ruby:2.7.0

# Set environment variables
ENV RAILS_ROOT /var/www/app_name
ENV RAILS_ENV production
ENV NODE_ENV production
ENV RACK_ENV production
ENV RAILS_LOG_TO_STDOUT true
ENV RAILS_SERVE_STATIC_FILES true

ARG RAILS_MASTER_KEY
RUN export RAILS_MASTER_KEY=${RAILS_MASTER_KEY}

WORKDIR /app

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs yarn
RUN apt-get install freetds-dev -y

# Copy Gemfile and install gems
COPY Gemfile Gemfile.lock /app/
RUN gem install bundler && bundle install --deployment --without development test --jobs 20 --retry 5

# Copy the rest of the application code
COPY . /app/

RUN echo $RAILS_MASTER_KEY > /app/config/master.key

# Expose port 3000 to the Docker host, so we can access the app
EXPOSE 3000

# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]
