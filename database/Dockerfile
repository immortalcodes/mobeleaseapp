FROM postgres
ENV POSTGRES_DB mobelease
ENV POSTGRES_USER admin
ENV POSTGRES_PASSWORD admin1234
COPY init.sql /docker-entrypoint-initdb.d/
COPY  mydb.tar /
COPY  script.sh /

# CMD ["pg_restore -U admin -Ft -d mobelease < mydb.tar"]
# CMD ["psql", "'dbname=mobelease  user=admin password=admin1234 port=5432'"]

