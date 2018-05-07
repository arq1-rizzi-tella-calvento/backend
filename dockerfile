# https://github.com/sickp/docker-alpine-ruby#242-r2-242
from sickp/alpine-ruby:2.4.2-r2

#por error nokogiri dependencia . https://github.com/gliderlabs/docker-alpine/issues/53
#run apk add --no-cache build-base

#por error con sqlite3 dependencia. https://stackoverflow.com/questions/421225/why-cant-i-install-the-sqlite-gem
#run apk add --no-cache sqlite-dev

#error tzdata . https://jbhannah.net/articles/rails-development-with-docker/
#run apk add --no-cache tzdata

run \
  apk add --no-cache \
    nodejs \
    build-base \
    sqlite-dev \
    postgresql-dev \
    tzdata


copy Gemfile /usr/src/Gemfile
copy Gemfile.lock /usr/src/Gemfile.lock
# copy . /usr/src/

workdir /usr/src/

run bundle install

copy . /usr/src/

# run rake db:create db:setup

expose 3000

# cmd ["rails", "s"] 

run chmod +x runme.sh

# cmd [ "bundle", "exec", "puma", "-C", "config/puma.rb" ]
cmd [ "./runme.sh" ]