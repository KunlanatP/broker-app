FROM golang:1.25-alpine AS builder

WORKDIR /app

RUN apk add --no-cache git

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN go install github.com/pressly/goose/v3/cmd/goose@latest
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o app ./cmd/api

FROM alpine:3.19

WORKDIR /app

RUN apk add --no-cache ca-certificates netcat-openbsd tzdata

COPY --from=builder /app/app /app/app
COPY --from=builder /go/bin/goose /app/goose
COPY --from=builder /app/migrations /app/migrations
COPY --from=builder /app/scripts /app/scripts

RUN chmod +x /app/scripts/*.sh

EXPOSE 8080

ENTRYPOINT ["/app/scripts/entrypoint.sh"]