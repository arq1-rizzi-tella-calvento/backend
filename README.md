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


## Docker

* Para buildear imagen requerida para docker compose (con root en el proyecto)

```
  docker build -t arq2/backend .
```

* Para levantar docker compose con db y app :

```
  docker-compose up 
  docker-compose up -d
```

(-d es opcional para dejarlo como daemon)

* Para colarse en los containers :

```
  docker exec -it backend_app_1 sh
  docker exec -it backend_db_1 psql -U postgres
```

* curl rápido a la api : 

```
  curl --silent -H 'Token: <token>' http://localhost:3000/summary
```

