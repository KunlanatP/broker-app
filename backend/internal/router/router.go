package router

import (
	"com.kunlanat.github/broker-api/internal/domain/broker"
	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
	"gorm.io/gorm"
)

func Register(app *fiber.App, db *gorm.DB) {
	app.Use(cors.New())

	repo := broker.NewRepository(db)
	service := broker.NewService(repo)
	handler := broker.NewHandler(service)

	api := app.Group("/api")
	brokers := api.Group("/brokers")

	brokers.Post("/", handler.Create)
	brokers.Get("/", handler.FindAll)
	brokers.Get("/:slug", handler.FindBySlug)
}
