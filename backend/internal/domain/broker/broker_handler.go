package broker

import (
	"bytes"
	"encoding/json"
	"errors"
	"time"

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

	return response.Success(c, fiber.StatusCreated, "broker created", toBrokerJSON(data))
}

func (h *Handler) FindAll(c *fiber.Ctx) error {
	search := c.Query("search")
	brokerType := c.Query("type")

	data, err := h.service.FindAll(search, brokerType)
	if err != nil {
		return response.Error(c, fiber.StatusInternalServerError, "failed to fetch brokers")
	}

	out := make([]brokerJSON, len(data))
	for i := range data {
		out[i] = toBrokerJSON(data[i])
	}

	return response.Success(c, fiber.StatusOK, "success", out)
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

	return response.Success(c, fiber.StatusOK, "success", toBrokerJSON(data))
}

type brokerJSON struct {
	ID          uint64          `json:"id"`
	Name        string          `json:"name"`
	Slug        string          `json:"slug"`
	Description string          `json:"description"`
	LogoURL     string          `json:"logo_url"`
	Website     string          `json:"website"`
	BrokerType  string          `json:"broker_type"`
	Detail      json.RawMessage `json:"detail"`
	CreatedAt   time.Time       `json:"created_at"`
	UpdatedAt   time.Time       `json:"updated_at"`
}

func toBrokerJSON(b Broker) brokerJSON {
	detail := json.RawMessage(`{}`)
	if len(bytes.TrimSpace(b.Detail)) > 0 {
		detail = json.RawMessage(b.Detail)
	}
	return brokerJSON{
		ID:          b.ID,
		Name:        b.Name,
		Slug:        b.Slug,
		Description: b.Description,
		LogoURL:     b.LogoURL,
		Website:     b.Website,
		BrokerType:  b.BrokerType,
		Detail:      detail,
		CreatedAt:   b.CreatedAt,
		UpdatedAt:   b.UpdatedAt,
	}
}
