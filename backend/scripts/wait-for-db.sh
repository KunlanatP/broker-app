#!/bin/sh

echo "waiting for postgres..."

until nc -z postgres 5432; do
  sleep 1
done

echo "postgres is ready"