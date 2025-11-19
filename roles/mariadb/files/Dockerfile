FROM mariadb:12.0.2-noble

COPY conf/mariadb-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY --chmod=755 conf/init_sql.sh /docker-entrypoint-initdb.d/
