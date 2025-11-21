FROM caddy:2.10.2-builder-alpine AS builder

ENV CGO_ENABLED=1

RUN apk add --no-cache gcc g++ libc-dev

RUN xcaddy build \
	--with github.com/caddy-dns/cloudflare

FROM caddy:2.10.2-alpine

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

COPY conf/Caddyfile /etc/caddy/Caddyfile
