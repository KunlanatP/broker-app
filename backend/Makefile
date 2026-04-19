APP_PORT=8080
DB_DSN=host=localhost port=5432 user=postgres password=postgres dbname=broker_db sslmode=disable

up:
	docker compose up -d

down:
	docker compose down

logs:
	docker compose logs -f

run:
	go run ./cmd/api

migrate-up:
	goose -dir migrations postgres "$(DB_DSN)" up

migrate-down:
	goose -dir migrations postgres "$(DB_DSN)" down

migrate-status:
	goose -dir migrations postgres "$(DB_DSN)" status