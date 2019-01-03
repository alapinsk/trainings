#!/bin/bash

# initial build including wwi backup files and restore script
docker build . --rm -t mssql2019-wwi-test:temp

# start a docker container to further build layers.
docker run --name mssql2019wwi -p 1433:1433 -d mssql2019-wwi-test:temp

# wait for mssql to start
sleep 15

docker ps

dt=`date '+%Y-%m-%d_%H-%M-%S'`

docker commit mssql2019wwi lapinskian/mssql2019wwi:$dt
docker tag lapinskian/mssql2019wwi:$dt lapinskian/mssql2019wwi:latest

docker push lapinskian/mssql2019wwi:$dt
docker push lapinskian/mssql2019wwi:latest