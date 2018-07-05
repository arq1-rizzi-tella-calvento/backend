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
  docker-compose build
```

* Para levantar la aplicación con docker compose `docker-compose up -d --build --scale backend=2`

Notar flag `--scale backend=2` . en el archivo nginx.conf asumimos que existen dos instancas de backend para balanceo.

### JMETER imagen

Una vez arriba los contenedores, podemos usar el container jmeter para correr los test de jmeter.

* `docker exec -it backend_jmeter_1 sh`
* `./jmeter -nt 250alu50doc30sec.jmx` 


