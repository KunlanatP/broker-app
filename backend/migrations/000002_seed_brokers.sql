-- +goose Up
INSERT INTO brokers (name, slug, description, logo_url, website, broker_type)
VALUES
(
  'Vanguard Capital',
  'vanguard-capital',
  'High-frequency CFD execution across Asian markets.',
  'https://example.com/vanguard.png',
  'https://vanguard.com',
  'cfd'
),
(
  'Meridian Bonds',
  'meridian-bonds',
  'Sovereign debt and corporate bond indexing.',
  'https://example.com/meridian.png',
  'https://meridian.com',
  'bond'
),
(
  'Apex Equities',
  'apex-equities',
  'Low-latency stock execution on global exchanges.',
  'https://example.com/apex.png',
  'https://apex.com',
  'stock'
),
(
  'BlockStream Prime',
  'blockstream-prime',
  'Digital asset brokerage and crypto liquidity.',
  'https://example.com/blockstream.png',
  'https://blockstream.com',
  'crypto'
);

-- +goose Down
DELETE FROM brokers WHERE slug IN (
  'vanguard-capital',
  'meridian-bonds',
  'apex-equities',
  'blockstream-prime'
);