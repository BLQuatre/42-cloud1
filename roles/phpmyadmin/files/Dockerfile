FROM phpmyadmin:5.2.3-fpm-alpine

USER root

RUN apk add --no-cache \
    netcat-openbsd \
    && rm -rf /var/cache/apk/*

COPY tools/wait-for-db.sh /usr/local/bin/wait-for-db.sh
RUN chmod +x /usr/local/bin/wait-for-db.sh

USER www-data

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/wait-for-db.sh"]
CMD ["php-fpm"]