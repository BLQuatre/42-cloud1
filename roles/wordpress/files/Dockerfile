FROM alpine:3.22.2

RUN apk update --no-cache \
	&& apk add --no-cache curl php84 php84-fpm php84-mbstring php84-phar php84-tokenizer php84-mysqli php84-opcache mariadb-client \
	&& ln -s /usr/bin/php84 /usr/bin/php \
	&& rm -rf /var/cache/apk/*

RUN adduser -D -u 82 -G www-data www-data

WORKDIR /var/www

RUN curl -o /usr/local/bin/wp -L https://github.com/wp-cli/wp-cli/releases/download/v2.11.0/wp-cli-2.11.0.phar \
	&& chmod +x /usr/local/bin/wp

COPY conf/memory.ini /etc/php84/conf.d/memory.ini

RUN wp core download --path=/var/www/wordpress --allow-root \
	&& chown -R www-data:www-data /var/www/wordpress

COPY conf/www.conf /etc/php84/php-fpm.d/www.conf

COPY tools/entrypoint.sh /opt/entrypoint.sh
RUN chmod +x /opt/entrypoint.sh

WORKDIR /var/www/wordpress

RUN mkdir -p /var/run/php

ENTRYPOINT ["/opt/entrypoint.sh"]
CMD ["/usr/sbin/php-fpm84", "-F"]
