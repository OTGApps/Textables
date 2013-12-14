#!/usr/bin/env sh

bundle install &&
bundle exec rake clean &&
bundle exec rake pod:install &&
bundle exec rake spec
