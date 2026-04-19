-- +goose Up
CREATE TABLE brokers (
  id BIGSERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  slug VARCHAR(255) NOT NULL UNIQUE,
  description TEXT NOT NULL,
  logo_url TEXT NOT NULL,
  website TEXT NOT NULL,
  broker_type VARCHAR(20) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT brokers_broker_type_check
    CHECK (broker_type IN ('cfd', 'bond', 'stock', 'crypto'))
);

CREATE INDEX idx_brokers_name ON brokers(name);
CREATE INDEX idx_brokers_slug ON brokers(slug);
CREATE INDEX idx_brokers_broker_type ON brokers(broker_type);

-- +goose Down
DROP TABLE IF EXISTS brokers;