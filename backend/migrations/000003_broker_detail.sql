-- +goose Up
ALTER TABLE brokers
  ADD COLUMN detail JSONB NOT NULL DEFAULT '{}'::jsonb;

INSERT INTO brokers (name, slug, description, logo_url, website, broker_type, detail)
SELECT
  'Blackwood Capital Markets',
  'blackwood-capital-markets',
  'Founded in 1994, Blackwood Capital Markets has served sovereign institutions and family offices with a singular mandate: absolute execution integrity. Our infrastructure spans low-latency fiber arrays linking London, New York, and Singapore, ensuring that institutional flow is matched against deep, disclosed liquidity pools without compromise.' || E'\n\n' ||
  'The Sterling Core matching engine powers algorithmic strategies with deterministic latency profiles. Risk is monitored continuously across asset classes, with segregated custody and independent audit trails aligned to global regulatory expectations.',
  'https://images.unsplash.com/photo-1560179707-f14e90ef3623?auto=format&fit=crop&w=400&q=80',
  'https://blackwood-capital.com',
  'stock',
  '{"tagline":"The definitive platform for sovereign wealth management and high-velocity algorithmic execution.","hero_image_url":"https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?auto=format\u0026fit=crop\u0026w=1920\u0026q=80","address":"One Canary Wharf, London, E14 5AB","contact_email":"institutional@blackwood.cap","display_domain":"blackwood-capital.com","regulation_title":"SEC \u0026 FCA Regulated","regulation_body":"Dual jurisdiction licensing with strict adherence to global mandates across North America and Europe.","execution_title":"12ms Execution","execution_body":"Sterling Core engine orchestrates orders across co-located matching engines with fiber-linked data centers.","metric_aum":"+24.8%","metric_liquidity":"$12.4B","metric_retention":"98.2%","prospectus_url":"https://blackwood-capital.com","markets":[{"label":"FOREX PAIRS","value":"80+"},{"label":"INDICES","value":"25"},{"label":"COMMODITIES","value":"18"},{"label":"EQUITIES","value":"4,000+"},{"label":"SOVEREIGN BONDS","value":"12"},{"label":"CRYPTO ETPS","value":"5"}]}'::jsonb
WHERE NOT EXISTS (SELECT 1 FROM brokers WHERE slug = 'blackwood-capital-markets');

UPDATE brokers SET detail = '{"tagline":"Multi-venue CFD execution with institutional-grade risk controls and disclosed liquidity.","hero_image_url":"https://images.unsplash.com/photo-1511818966892-d7d671c56e68?auto=format\u0026fit=crop\u0026w=1920\u0026q=80","address":"30 St Mary Axe, London, EC3A 8BF","contact_email":"desk@vanguard.example.com","regulation_title":"FCA Regulated","regulation_body":"Client money held in tier-one banks with daily reconciliation and EMIR reporting.","execution_title":"Sub-20ms Execution","execution_body":"Smart routing across tier-one venues with failover between matching engines.","metric_aum":"+18.2%","metric_liquidity":"$8.1B","metric_retention":"96.4%","prospectus_url":"https://vanguard.com","markets":[{"label":"FOREX PAIRS","value":"72+"},{"label":"INDICES","value":"22"},{"label":"COMMODITIES","value":"14"},{"label":"EQUITIES","value":"2,800+"},{"label":"SOVEREIGN BONDS","value":"9"},{"label":"CRYPTO ETPS","value":"4"}]}'::jsonb
WHERE slug = 'vanguard-capital';

UPDATE brokers SET detail = '{"tagline":"Primary and secondary sovereign debt with independent credit research desks.","hero_image_url":"https://images.unsplash.com/photo-1448630360428-65456885c650?auto=format\u0026fit=crop\u0026w=1920\u0026q=80","address":"175 Bishopsgate, London, EC2M 3AE","contact_email":"fixedincome@meridian.example.com","regulation_title":"SEC \u0026 BaFin Aligned","regulation_body":"Compliance frameworks mapped to EU and US fixed-income distribution rules.","execution_title":"Voice \u0026 electronic hybrid","execution_body":"Dedicated desk coverage with streaming axes into disclosed inventory.","metric_aum":"+11.4%","metric_liquidity":"$22.6B","metric_retention":"97.1%","prospectus_url":"https://meridian.com","markets":[{"label":"FOREX PAIRS","value":"40+"},{"label":"INDICES","value":"18"},{"label":"COMMODITIES","value":"8"},{"label":"EQUITIES","value":"1,200+"},{"label":"SOVEREIGN BONDS","value":"340+"},{"label":"CRYPTO ETPS","value":"2"}]}'::jsonb
WHERE slug = 'meridian-bonds';

UPDATE brokers SET detail = '{"tagline":"Global equity execution with smart order routing and block crossing.","hero_image_url":"https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?auto=format\u0026fit=crop\u0026w=1920\u0026q=80","address":"Canary Wharf, London, E14 5JP","contact_email":"eq@apex.example.com","regulation_title":"MiFID II Best Execution","regulation_body":"Annual RTS 27 reports published with venue-level quality metrics.","execution_title":"9ms Median Latency","execution_body":"Co-located gateways at major exchanges with deterministic capacity.","metric_aum":"+31.0%","metric_liquidity":"$15.2B","metric_retention":"98.8%","prospectus_url":"https://apex.com","markets":[{"label":"FOREX PAIRS","value":"55+"},{"label":"INDICES","value":"40"},{"label":"COMMODITIES","value":"12"},{"label":"EQUITIES","value":"8,500+"},{"label":"SOVEREIGN BONDS","value":"18"},{"label":"CRYPTO ETPS","value":"6"}]}'::jsonb
WHERE slug = 'apex-equities';

UPDATE brokers SET detail = '{"tagline":"Digital asset liquidity with institutional custody and on-chain attestation.","hero_image_url":"https://images.unsplash.com/photo-1639762681485-074b7f938ba0?auto=format\u0026fit=crop\u0026w=1920\u0026q=80","address":"One Canada Square, London, E14 5AB","contact_email":"prime@blockstream.example.com","regulation_title":"Multi-jurisdiction licensing","regulation_body":"Travel rule compliance and cold-wallet segregation for client assets.","execution_title":"4ms Internal Match","execution_body":"Crossing network with disclosed maker incentives and surveillance tooling.","metric_aum":"+42.5%","metric_liquidity":"$3.8B","metric_retention":"95.2%","prospectus_url":"https://blockstream.com","markets":[{"label":"FOREX PAIRS","value":"35+"},{"label":"INDICES","value":"12"},{"label":"COMMODITIES","value":"6"},{"label":"EQUITIES","value":"900+"},{"label":"SOVEREIGN BONDS","value":"4"},{"label":"CRYPTO ETPS","value":"140+"}]}'::jsonb
WHERE slug = 'blockstream-prime';

-- +goose Down
DELETE FROM brokers WHERE slug = 'blackwood-capital-markets';

UPDATE brokers SET detail = '{}'::jsonb;

ALTER TABLE brokers DROP COLUMN detail;
