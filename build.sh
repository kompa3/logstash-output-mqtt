#!/bin/bash
set -ex

# This script builds the plugin in correct JRuby environment using dockerized build environment

if [ ! -f /.dockerinit ]; then
  echo "Launching build script inside dockerized build environment ..."

  # Check if docker is installed in the system
  hash docker 2>/dev/null || { echo >&2 "Docker is not installed. Install it from https://docs.docker.com/engine/installation/. Aborting build."; exit 1; }

  # Make sure that latest jruby image has been pulled for Docker Hub
  docker pull jruby:latest

  # Execute the build script in jruby docker container
  USER_ID=$(id -u)
  DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  docker run --rm $([ -t 0 ] && echo "-ti") \
    -v "$DIR":"$DIR" \
    -w="$DIR" \
    -e "HOST_USER_ID=$USER_ID" \
    jruby:latest "$DIR/build.sh"

else
  echo "Running build commands inside dockerized build environment ..."

  # Install plugin dependencies
  bundle install

  # Run tests
  TEST_DEBUG=1 bundle exec rspec

  # Build gem
  gem build logstash-output-mqtt.gemspec

  # Fix file ownership because docker environment only has root user
  chown "$HOST_USER_ID"."$HOST_USER_ID" *.gem

  echo "Built successfully"
  echo "To register the plugin in your current logstash installation, run:"
  echo "  sudo /opt/logstash/bin/plugin install logstash-output-mqtt-*.gem"
fi
