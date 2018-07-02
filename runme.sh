#!/bin/sh

rake db:migrate
rake db:seed

bundle exec puma -C config/puma.rb