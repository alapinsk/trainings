kubectl exec -ti mssql-0 -n production bash 

#run following commands in the kubernetes container terminal
cd /var/opt/mssql
mkdir -p backup
cd backup
wget https://github.com/Microsoft/sql-server-samples/releases/download/wide-world-importers-v0.2/WideWorldImporters-Full.bak
wget https://raw.githubusercontent.com/alapinsk/trainings/master/2019/01/powerbi-ml/docker-data-image/restore.sql
wget https://raw.githubusercontent.com/alapinsk/trainings/master/2019/01/powerbi-ml/docker-data-image/create_sp.sql
wget https://raw.githubusercontent.com/alapinsk/trainings/master/2019/01/powerbi-ml/docker-data-image/comments.sql

/opt/mssql-tools/bin/sqlcmd -U sa -P SqlDevOps2017 -i restore.sql
/opt/mssql-tools/bin/sqlcmd -U sa -P SqlDevOps2017 -i create_sp.sql
/opt/mssql-tools/bin/sqlcmd -U sa -P SqlDevOps2017 -i comments.sql

