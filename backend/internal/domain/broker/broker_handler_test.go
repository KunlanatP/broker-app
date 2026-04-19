package broker

import (
	"encoding/json"
	"net/http"
	"testing"
)

func TestHandlerCreateValidation(t *testing.T) {
	db := newTestDB(t)
	repo := NewRepository(db)
	svc := NewService(repo)
	app := newApp(svc)

	res, _ := do(t, app, http.MethodPost, "/api/brokers/", map[string]any{})
	if res.StatusCode != http.StatusBadRequest {
		t.Fatalf("status %d", res.StatusCode)
	}
}

func TestHandlerCreateAndFetch(t *testing.T) {
	db := newTestDB(t)
	repo := NewRepository(db)
	svc := NewService(repo)
	app := newApp(svc)

	payload := map[string]any{
		"name":        "Blackwood Capital Markets",
		"slug":        "blackwood-capital-markets",
		"description": "d",
		"logo_url":    "https://example.com/logo.png",
		"website":     "https://blackwood-capital.com",
		"broker_type": "stock",
	}

	res, raw := do(t, app, http.MethodPost, "/api/brokers/", payload)
	if res.StatusCode != http.StatusCreated {
		t.Fatalf("status %d body=%s", res.StatusCode, string(raw))
	}
	d := decodeData(t, raw)
	m := d.(map[string]any)
	if m["slug"] != "blackwood-capital-markets" {
		t.Fatalf("unexpected slug")
	}
	if _, ok := m["detail"].(map[string]any); !ok {
		t.Fatalf("detail not object")
	}

	res, raw = do(t, app, http.MethodGet, "/api/brokers/blackwood-capital-markets", nil)
	if res.StatusCode != http.StatusOK {
		t.Fatalf("status %d body=%s", res.StatusCode, string(raw))
	}
	m = decodeData(t, raw).(map[string]any)
	if m["name"] != "Blackwood Capital Markets" {
		t.Fatalf("unexpected name")
	}
}

func TestHandlerSlugConflict(t *testing.T) {
	db := newTestDB(t)
	repo := NewRepository(db)
	svc := NewService(repo)
	app := newApp(svc)

	payload := map[string]any{
		"name":        "A",
		"slug":        "a",
		"description": "d",
		"logo_url":    "https://example.com/logo.png",
		"website":     "https://a.com",
		"broker_type": "cfd",
	}

	res, _ := do(t, app, http.MethodPost, "/api/brokers/", payload)
	if res.StatusCode != http.StatusCreated {
		t.Fatalf("status %d", res.StatusCode)
	}

	res, _ = do(t, app, http.MethodPost, "/api/brokers/", payload)
	if res.StatusCode != http.StatusConflict {
		t.Fatalf("status %d", res.StatusCode)
	}
}

func TestHandlerFindAllQueryParams(t *testing.T) {
	db := newTestDB(t)
	repo := NewRepository(db)
	svc := NewService(repo)
	app := newApp(svc)

	insertBrokers(
		t,
		db,
		Broker{Name: "Blackwood Capital Markets", Slug: "blackwood", Description: "d", LogoURL: "https://e.com/a.png", Website: "https://a.com", BrokerType: "stock", Detail: []byte(`{"tagline":"x"}`)},
		Broker{Name: "BlockStream Prime", Slug: "blockstream", Description: "d", LogoURL: "https://e.com/b.png", Website: "https://b.com", BrokerType: "crypto", Detail: []byte(`{"tagline":"x"}`)},
	)

	res, raw := do(t, app, http.MethodGet, "/api/brokers/?type=crypto", nil)
	if res.StatusCode != http.StatusOK {
		t.Fatalf("status %d body=%s", res.StatusCode, string(raw))
	}
	data := decodeData(t, raw)
	arr := data.([]any)
	if len(arr) != 1 {
		t.Fatalf("unexpected len")
	}
	item := arr[0].(map[string]any)
	if item["slug"] != "blockstream" {
		t.Fatalf("unexpected slug")
	}
}

func TestHandlerFindBySlugNotFound(t *testing.T) {
	db := newTestDB(t)
	repo := NewRepository(db)
	svc := NewService(repo)
	app := newApp(svc)

	res, _ := do(t, app, http.MethodGet, "/api/brokers/not-found", nil)
	if res.StatusCode != http.StatusNotFound {
		t.Fatalf("status %d", res.StatusCode)
	}
}

func TestHandlerCreateWithDetail(t *testing.T) {
	db := newTestDB(t)
	repo := NewRepository(db)
	svc := NewService(repo)
	app := newApp(svc)

	detail := json.RawMessage(`{"tagline":"custom","markets":[{"label":"FOREX","value":"1"}]}`)
	payload := map[string]any{
		"name":        "A",
		"slug":        "a2",
		"description": "d",
		"logo_url":    "https://example.com/logo.png",
		"website":     "https://a.com",
		"broker_type": "cfd",
		"detail":      detail,
	}

	res, raw := do(t, app, http.MethodPost, "/api/brokers/", payload)
	if res.StatusCode != http.StatusCreated {
		t.Fatalf("status %d body=%s", res.StatusCode, string(raw))
	}
	m := decodeData(t, raw).(map[string]any)
	d := m["detail"].(map[string]any)
	if d["tagline"] != "custom" {
		t.Fatalf("unexpected tagline")
	}
}

