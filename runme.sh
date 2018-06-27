#!/bin/sh

rake db:migrate
rake db:seed

# rake assets:precompile

bundle exec puma -C config/puma.rb