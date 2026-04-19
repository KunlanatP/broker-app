import 'package:frontend/features/broker/domain/entities/broker.dart';

Broker sampleBroker() {
  final p = BrokerProfile.merge(
    {
      'tagline': 'The definitive platform for sovereign wealth management.',
      'hero_image_url': 'https://images.example.com/hero.jpg',
      'address': 'One Canary Wharf, London, E14 5AB',
      'contact_email': 'institutional@blackwood.cap',
      'display_domain': 'blackwood-capital.com',
      'regulation_title': 'SEC & FCA Regulated',
      'regulation_body': 'Dual oversight.',
      'execution_title': '12ms Execution',
      'execution_body': 'Low-latency routing.',
      'metric_aum': '+24.8%',
      'metric_liquidity': '\$12.4B',
      'metric_retention': '98.2%',
      'prospectus_url': 'https://blackwood-capital.com',
      'markets': [
        {'label': 'FOREX PAIRS', 'value': '80+'},
        {'label': 'INDICES', 'value': '25'},
      ],
    },
    name: 'Blackwood Capital Markets',
    slug: 'blackwood-capital-markets',
    description: 'd',
    website: 'https://blackwood-capital.com',
    brokerType: 'stock',
  );

  return Broker(
    id: 1,
    name: 'Blackwood Capital Markets',
    slug: 'blackwood-capital-markets',
    description: 'd',
    logoUrl: 'https://images.example.com/logo.png',
    website: 'https://blackwood-capital.com',
    brokerType: 'stock',
    profile: p,
  );
}

