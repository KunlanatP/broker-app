#!/bin/sh

/app/goose -dir /app/migrations postgres "$DB_DSN" up