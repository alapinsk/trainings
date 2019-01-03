FROM mcr.microsoft.com/mssql/server:2019-CTP2.2-ubuntu

ENV ACCEPT_EULA Y
ENV SA_PASSWORD SqlTest123!

WORKDIR /var/opt/mssql/backup
RUN wget https://github.com/Microsoft/sql-server-samples/releases/download/wide-world-importers-v1.0/WideWorldImporters-Full.bak

WORKDIR /opt/var/scripts
COPY restore.sql .
RUN ( /opt/mssql/bin/sqlservr --accept-eula & ) | grep -q "Service Broker manager has started" \
    && /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P ${SA_PASSWORD} -i restore.sql \
    && pkill sqlservr
