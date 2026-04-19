#!/bin/sh
goose -dir migrations postgres "host=localhost port=5432 user=postgres password=postgres dbname=broker_db sslmode=disable" down