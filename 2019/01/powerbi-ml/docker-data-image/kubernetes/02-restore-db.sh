kubectl exec -ti mssql-0 -n production bash 

#run following commands in the kubernetes container terminal
cd /var/opt/mssql
mkdir -p backup
cd backup
wget https://github.com/Microsoft/sql-server-samples/releases/download/wide-world-importers-v0.2/WideWorldImporters-Full.bak
/opt/mssql-tools/bin/sqlcmd -Usa -PSqlDevOps2017 -i restore.sql
