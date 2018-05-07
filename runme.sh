#!/bin/sh

rake db:migrate

bundle exec puma -C config/puma.rb