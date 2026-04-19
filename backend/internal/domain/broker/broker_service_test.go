package broker

import (
	"encoding/json"
	"testing"
)

type stubRepo struct {
	createFn       func(payload Broker) (Broker, error)
	findAllFn      func(search string, brokerType string) ([]Broker, error)
	findBySlugFn   func(slug string) (Broker, error)
	existsBySlugFn func(slug string) (bool, error)
}

func (s stubRepo) Create(payload Broker) (Broker, error) {
	return s.createFn(payload)
}
func (s stubRepo) FindAll(search string, brokerType string) ([]Broker, error) {
	return s.findAllFn(search, brokerType)
}
func (s stubRepo) FindBySlug(slug string) (Broker, error) {
	return s.findBySlugFn(slug)
}
func (s stubRepo) ExistsBySlug(slug string) (bool, error) {
	return s.existsBySlugFn(slug)
}

func TestServiceCreateGeneratesDetail(t *testing.T) {
	var created Broker
	repo := stubRepo{
		existsBySlugFn: func(string) (bool, error) { return false, nil },
		createFn: func(payload Broker) (Broker, error) {
			created = payload
			return payload, nil
		},
		findAllFn:    func(string, string) ([]Broker, error) { return nil, nil },
		findBySlugFn: func(string) (Broker, error) { return Broker{}, nil },
	}

	svc := NewService(repo)
	_, err := svc.Create(CreateBrokerRequest{
		Name:        "Blackwood Capital Markets",
		Slug:        "blackwood-capital-markets",
		Description: "x",
		LogoURL:     "https://example.com/logo.png",
		Website:     "https://blackwood-capital.com",
		BrokerType:  "stock",
	})
	if err != nil {
		t.Fatalf("create: %v", err)
	}
	if len(created.Detail) == 0 {
		t.Fatalf("detail empty")
	}
	var detail map[string]any
	if err := json.Unmarshal(created.Detail, &detail); err != nil {
		t.Fatalf("detail json: %v", err)
	}
	if _, ok := detail["tagline"]; !ok {
		t.Fatalf("missing tagline")
	}
	if _, ok := detail["markets"]; !ok {
		t.Fatalf("missing markets")
	}
}

func TestServiceCreateKeepsProvidedDetail(t *testing.T) {
	var created Broker
	repo := stubRepo{
		existsBySlugFn: func(string) (bool, error) { return false, nil },
		createFn: func(payload Broker) (Broker, error) {
			created = payload
			return payload, nil
		},
		findAllFn:    func(string, string) ([]Broker, error) { return nil, nil },
		findBySlugFn: func(string) (Broker, error) { return Broker{}, nil },
	}

	svc := NewService(repo)
	raw := json.RawMessage(`{"tagline":"custom","markets":[{"label":"A","value":"1"}]}`)
	_, err := svc.Create(CreateBrokerRequest{
		Name:        "A",
		Slug:        "a",
		Description: "x",
		LogoURL:     "https://example.com/logo.png",
		Website:     "https://a.com",
		BrokerType:  "cfd",
		Detail:      raw,
	})
	if err != nil {
		t.Fatalf("create: %v", err)
	}
	if string(created.Detail) != string(raw) {
		t.Fatalf("detail changed")
	}
}

func TestServiceCreateSlugConflict(t *testing.T) {
	repo := stubRepo{
		existsBySlugFn: func(string) (bool, error) { return true, nil },
		createFn:       func(payload Broker) (Broker, error) { return payload, nil },
		findAllFn:      func(string, string) ([]Broker, error) { return nil, nil },
		findBySlugFn:   func(string) (Broker, error) { return Broker{}, nil },
	}

	svc := NewService(repo)
	_, err := svc.Create(CreateBrokerRequest{
		Name:        "A",
		Slug:        "a",
		Description: "x",
		LogoURL:     "https://example.com/logo.png",
		Website:     "https://a.com",
		BrokerType:  "cfd",
	})
	if err == nil {
		t.Fatalf("expected error")
	}
	if err != ErrBrokerSlugExists {
		t.Fatalf("unexpected error: %v", err)
	}
}

