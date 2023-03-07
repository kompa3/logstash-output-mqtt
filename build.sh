#!/bin/bash
set -ex

# This script builds the plugin in correct JRuby environment using dockerized build environment

if [ ! "$1" = "true" ]; then
  echo "Launching build script inside dockerized build environment ..."

  # Check if docker is installed in the system
  hash docker 2>/dev/null || { echo >&2 "Docker is not installed. Install it from https://docs.docker.com/engine/installation/. Aborting build."; exit 1; }

  # Make sure that latest jruby image has been pulled for Docker Hub
  docker pull jruby:latest

  # Execute the build script in jruby docker container
  USER_ID=$(id -u)
  DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  HOME_DIR="$( cd ~/ && pwd )"
  docker run -ti --rm $([ -t 0 ] && echo "-ti") \
    -v "$DIR":"$DIR" \
    -v "/home/tommi/.ssh":"/root/.ssh" \
    -w="$DIR" \
    -e "HOST_USER_ID=$USER_ID" \
    -e "LOGSTASH_PATH=/usr/share/logstash" \
    -e "LOGSTASH_SOURCE=1" \
    jruby:9.3 "$DIR/build.sh" "true"

else
  echo "Running build commands inside dockerized build environment ..."

  # Install logstash
  apt-get update
  apt-get install -y gpg apt-transport-https
  wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | gpg --dearmor -o /usr/share/keyrings/elastic-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/elastic-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-8.x.list
  apt-get update && apt-get install logstash

  # Install plugin dependencies
  bundle install

  # Run tests
  TEST_DEBUG=1 bundle exec rspec

  # Build gem
  gem build logstash-output-mqtt.gemspec

  # Fix file ownership because docker environment only has root user
  chown "$HOST_USER_ID"."$HOST_USER_ID" *.gem

  set +x
  echo "Built successfully"
  echo "If do not want to publish a new version of the gem just yet, type exit"
  echo "To continue with publishing the gem, check that the version of gemspec file is correct and do the following:"
  echo "   curl -u username:password https://rubygems.org/api/v1/api_key.yaml > ~/.gem/credentials"
  echo "   chmod 0600 ~/.gem/credentials"
  echo "   apt-get update && apt-get install -y git"
  echo "   bundle exec rake vendor"
  echo "   bundle exec rake publish_gem"

  # Allow the user to publish the gem
  /bin/bash

  echo "To register the plugin in your current logstash installation, run:"
  echo "  sudo /opt/logstash/bin/plugin install logstash-output-mqtt-*.gem"
fi
