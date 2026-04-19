import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/broker/domain/entities/broker.dart';

void main() {
  test('merge falls back when detail missing', () {
    final p = BrokerProfile.merge(
      null,
      name: 'Blackwood Capital Markets',
      slug: 'blackwood-capital-markets',
      description: 'Line one\nLine two',
      website: 'https://blackwood-capital.com',
      brokerType: 'stock',
    );

    expect(p.tagline.isNotEmpty, true);
    expect(p.displayDomain, 'blackwood-capital.com');
    expect(p.markets.length, 6);
  });

  test('merge uses provided detail', () {
    final p = BrokerProfile.merge(
      {
        'tagline': 'Custom tagline',
        'display_domain': 'example.org',
        'metric_aum': '+1.0%',
        'markets': [
          {'label': 'FOREX', 'value': '1'},
          {'label': 'INDICES', 'value': '2'},
        ],
      },
      name: 'A',
      slug: 'a',
      description: '',
      website: 'https://a.com',
      brokerType: 'cfd',
    );

    expect(p.tagline, 'Custom tagline');
    expect(p.displayDomain, 'example.org');
    expect(p.metricAum, '+1.0%');
    expect(p.markets.length, 2);
    expect(p.markets.first.label, 'FOREX');
  });
}

