package broker

import (
	"errors"

	"com.kunlanat.github/broker-api/internal/response"
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
)

type Handler struct {
	service Service
}

func NewHandler(service Service) *Handler {
	return &Handler{service: service}
}

func (h *Handler) Create(c *fiber.Ctx) error {
	var req CreateBrokerRequest

	if err := c.BodyParser(&req); err != nil {
		return response.Error(c, fiber.StatusBadRequest, "invalid request body")
	}

	data, err := h.service.Create(req)
	if err != nil {
		var validationErr validator.ValidationErrors

		if errors.As(err, &validationErr) {
			return response.Error(c, fiber.StatusBadRequest, err.Error())
		}

		if errors.Is(err, ErrBrokerSlugExists) {
			return response.Error(c, fiber.StatusConflict, err.Error())
		}

		return response.Error(c, fiber.StatusInternalServerError, "failed to create broker")
	}

	return response.Success(c, fiber.StatusCreated, "broker created", data)
}

func (h *Handler) FindAll(c *fiber.Ctx) error {
	search := c.Query("search")
	brokerType := c.Query("type")

	data, err := h.service.FindAll(search, brokerType)
	if err != nil {
		return response.Error(c, fiber.StatusInternalServerError, "failed to fetch brokers")
	}

	return response.Success(c, fiber.StatusOK, "success", data)
}

func (h *Handler) FindBySlug(c *fiber.Ctx) error {
	slug := c.Params("slug")

	data, err := h.service.FindBySlug(slug)
	if err != nil {
		if errors.Is(err, ErrBrokerNotFound) {
			return response.Error(c, fiber.StatusNotFound, err.Error())
		}

		return response.Error(c, fiber.StatusInternalServerError, "failed to fetch broker")
	}

	return response.Success(c, fiber.StatusOK, "success", data)
}
