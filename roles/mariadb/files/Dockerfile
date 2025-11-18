FROM mariadb:12.0.2-ubi10

COPY conf/mariadb-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY conf/init.sql /docker-entrypoint-initdb.d/init.sql
