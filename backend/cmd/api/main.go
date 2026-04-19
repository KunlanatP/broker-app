package main

import (
	"log"

	"com.kunlanat.github/broker-api/internal/config"
	"com.kunlanat.github/broker-api/internal/database"
	"com.kunlanat.github/broker-api/internal/router"
	"github.com/gofiber/fiber/v2"
)

func main() {
	env := config.LoadEnv()
	db := database.NewPostgres(env)

	app := fiber.New()

	router.Register(app, db)

	log.Fatal(app.Listen(":" + env.AppPort))
}
