#!/bin/sh

set -e

host="${PMA_HOST}"
port="${PMA_PORT}"

max_attempts=30
attempt=0

while [ $attempt -lt $max_attempts ]; do
    if nc -z "$host" "$port" 2>/dev/null; then
        echo "MySQL is ready!"
        break
    fi
    
    attempt=$((attempt + 1))
    sleep 2
done

if [ $attempt -eq $max_attempts ]; then
    echo "ERROR: MySQL connection timeout"
    exit 1
fi

exec "$@"
