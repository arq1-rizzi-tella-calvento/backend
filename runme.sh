#!/bin/sh

rake db:seed
rake db:migrate

# rake assets:precompile

bundle exec puma -C config/puma.rb