from openjdk:alpine

workdir /usr/src/

run \
  apk add --no-cache \
    curl \
    postgresql-client

run curl http://www-us.apache.org/dist//jmeter/binaries/apache-jmeter-4.0.tgz --output apache-jmeter-4.0.tgz
run tar -xzvf apache-jmeter-4.0.tgz
run ln -s apache-jmeter-4.0/bin/jmeter jmeter

# run PGPASSWORD=example psql -h db -U postgres  -t -c "select token from students limit 1" | tr -d " \t\r\n"


copy jmeter/* .