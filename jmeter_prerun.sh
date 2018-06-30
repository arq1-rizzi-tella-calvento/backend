#!/bin/sh

TOKEN=$( PGPASSWORD=example psql -h db -U postgres  -t -c "select token from students limit 1" | tr -d " \t\r\n" ) 
echo $TOKEN
sed -i "s/TOKEN_HEADER/$TOKEN/g" *.jmx

tail -f /dev/null