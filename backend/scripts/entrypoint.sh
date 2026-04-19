#!/bin/sh
set -e

echo "waiting for postgres..."

until nc -z postgres 5432; do
  sleep 1
done

echo "postgres is ready"
echo "DB_DSN=$DB_DSN"

if [ -z "$DB_DSN" ]; then
  echo "DB_DSN is empty"
  exit 1
fi

/app/goose -dir /app/migrations postgres "$DB_DSN" up

exec /app/app