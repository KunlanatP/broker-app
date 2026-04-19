package broker

import (
	"bytes"
	"encoding/json"
	"errors"

	"github.com/go-playground/validator/v10"
	"gorm.io/gorm"
)

var (
	ErrBrokerSlugExists = errors.New("broker slug already exists")
	ErrBrokerNotFound   = errors.New("broker not found")
)

type Service interface {
	Create(req CreateBrokerRequest) (Broker, error)
	FindAll(search string, brokerType string) ([]Broker, error)
	FindBySlug(slug string) (Broker, error)
}

type service struct {
	repo      Repository
	validator *validator.Validate
}

func NewService(repo Repository) Service {
	return &service{
		repo:      repo,
		validator: validator.New(),
	}
}

func (s *service) Create(req CreateBrokerRequest) (Broker, error) {
	if err := s.validator.Struct(req); err != nil {
		return Broker{}, err
	}

	exists, err := s.repo.ExistsBySlug(req.Slug)
	if err != nil {
		return Broker{}, err
	}

	if exists {
		return Broker{}, ErrBrokerSlugExists
	}

	detailBytes, err := resolveCreateDetail(req)
	if err != nil {
		return Broker{}, err
	}

	payload := Broker{
		Name:        req.Name,
		Slug:        req.Slug,
		Description: req.Description,
		LogoURL:     req.LogoURL,
		Website:     req.Website,
		BrokerType:  req.BrokerType,
		Detail:      detailBytes,
	}

	return s.repo.Create(payload)
}

func (s *service) FindAll(search string, brokerType string) ([]Broker, error) {
	return s.repo.FindAll(search, brokerType)
}

func (s *service) FindBySlug(slug string) (Broker, error) {
	broker, err := s.repo.FindBySlug(slug)
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return Broker{}, ErrBrokerNotFound
		}
		return Broker{}, err
	}

	return broker, nil
}

func resolveCreateDetail(req CreateBrokerRequest) ([]byte, error) {
	raw := bytes.TrimSpace(req.Detail)
	if len(raw) == 0 || string(raw) == "null" || string(raw) == "{}" {
		d := NewSeededDetail(req.Name, req.Slug, req.Website, req.BrokerType)
		return json.Marshal(d)
	}
	var check map[string]interface{}
	if err := json.Unmarshal(raw, &check); err != nil {
		return nil, err
	}
	return raw, nil
}