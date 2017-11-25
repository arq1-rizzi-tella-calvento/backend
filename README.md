# README

## Setup
Ruby version: 2.4.2

* `gem install bundler`

* `bundle install --without production`

* DB (Dev): `rake db:create db:setup` (sqlite)

* Server: `rails s` => localhost:3000

### Tests

* DB (Test): `RAILS_ENV=test rake db:create db:migrate`

* Tests: `rspec`

### Misc

* Terminal: `rails c`

* Migraciones: `rake db:migrate`

* Seeds: `rake db:seed`
