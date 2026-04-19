package broker

import (
	"bytes"
	"encoding/json"
	"io"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/gofiber/fiber/v2"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
)

func newTestDB(t *testing.T) *gorm.DB {
	t.Helper()
	db, err := gorm.Open(sqlite.Open(":memory:"), &gorm.Config{})
	if err != nil {
		t.Fatalf("open db: %v", err)
	}
	if err := db.AutoMigrate(&Broker{}); err != nil {
		t.Fatalf("migrate: %v", err)
	}
	return db
}

func insertBrokers(t *testing.T, db *gorm.DB, items ...Broker) {
	t.Helper()
	for i := range items {
		if err := db.Create(&items[i]).Error; err != nil {
			t.Fatalf("insert: %v", err)
		}
	}
}

func newApp(svc Service) *fiber.App {
	app := fiber.New()
	h := NewHandler(svc)
	api := app.Group("/api")
	b := api.Group("/brokers")
	b.Post("/", h.Create)
	b.Get("/", h.FindAll)
	b.Get("/:slug", h.FindBySlug)
	return app
}

func do(t *testing.T, app *fiber.App, method, path string, body any) (*http.Response, []byte) {
	t.Helper()
	var r io.Reader
	if body != nil {
		b, err := json.Marshal(body)
		if err != nil {
			t.Fatalf("marshal: %v", err)
		}
		r = bytes.NewReader(b)
	}
	req := httptest.NewRequest(method, path, r)
	if body != nil {
		req.Header.Set("Content-Type", "application/json")
	}
	res, err := app.Test(req, -1)
	if err != nil {
		t.Fatalf("test req: %v", err)
	}
	raw, err := io.ReadAll(res.Body)
	if err != nil {
		t.Fatalf("read body: %v", err)
	}
	return res, raw
}

func decodeData(t *testing.T, raw []byte) any {
	t.Helper()
	var m map[string]any
	if err := json.Unmarshal(raw, &m); err != nil {
		t.Fatalf("unmarshal: %v", err)
	}
	return m["data"]
}

