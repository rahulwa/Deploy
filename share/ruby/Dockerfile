FROM ruby:2.5.1-alpine3.7
LABEL maintainer="ji@rahulwa.com"
ENV DEFAULT_PACKAGES build-base
RUN apk add --no-cache --update $DEFAULT_PACKAGES \
# Other dependencies

ENV APP_PATH /app
WORKDIR $APP_PATH
ADD Gemfile Gemfile.lock $APP_PATH/
RUN bundle install --jobs `expr $(cat /proc/cpuinfo | grep -c "cpu cores") - 1` --retry 2 --no-cache --clean
# RUN bundle exec rake asset:precompile
# Copy the app files into the container
COPY . APP_PATH
EXPOSE 3000