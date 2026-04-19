class MarketStat {
  final String label;
  final String value;

  const MarketStat({required this.label, required this.value});
}

class BrokerProfile {
  final String tagline;
  final String heroImageUrl;
  final String address;
  final String contactEmail;
  final String displayDomain;
  final String regulationTitle;
  final String regulationBody;
  final String executionTitle;
  final String executionBody;
  final String metricAum;
  final String metricLiquidity;
  final String metricRetention;
  final String prospectusUrl;
  final List<MarketStat> markets;

  const BrokerProfile({
    required this.tagline,
    required this.heroImageUrl,
    required this.address,
    required this.contactEmail,
    required this.displayDomain,
    required this.regulationTitle,
    required this.regulationBody,
    required this.executionTitle,
    required this.executionBody,
    required this.metricAum,
    required this.metricLiquidity,
    required this.metricRetention,
    required this.prospectusUrl,
    required this.markets,
  });

  factory BrokerProfile.merge(
    Map<String, dynamic>? detail, {
    required String name,
    required String slug,
    required String description,
    required String website,
    required String brokerType,
  }) {
    String firstLine(String d) {
      final t = d.trim();
      if (t.isEmpty) {
        return '$name delivers institutional execution with disclosed liquidity.';
      }
      return t.split('\n').first.trim();
    }

    String host(String w) {
      final u = Uri.tryParse(w);
      if (u == null || u.host.isEmpty) return 'example.com';
      return u.host.startsWith('www.') ? u.host.substring(4) : u.host;
    }

    List<MarketStat> marketsFrom(Map<String, dynamic> src) {
      final raw = src['markets'];
      if (raw is! List || raw.isEmpty) {
        return _defaultMarkets(brokerType);
      }
      final out = <MarketStat>[];
      for (final e in raw) {
        if (e is Map) {
          final m = Map<String, dynamic>.from(e);
          out.add(
            MarketStat(
              label: m['label']?.toString() ?? '',
              value: m['value']?.toString() ?? '',
            ),
          );
        }
      }
      return out.isEmpty ? _defaultMarkets(brokerType) : out;
    }

    final d = detail;
    if (d == null || d.isEmpty) {
      return BrokerProfile(
        tagline: firstLine(description),
        heroImageUrl: '',
        address: 'One Exchange Square, London',
        contactEmail: 'institutional@$slug.example.com',
        displayDomain: host(website),
        regulationTitle: 'SEC & FCA Regulated',
        regulationBody:
            'Dual oversight across major jurisdictions with segregated client assets.',
        executionTitle: '12ms Execution',
        executionBody:
            'Low-latency routing with smart order placement across tier-one venues.',
        metricAum: '+24.8%',
        metricLiquidity: '\$12.4B',
        metricRetention: '98.2%',
        prospectusUrl: website,
        markets: _defaultMarkets(brokerType),
      );
    }

    return BrokerProfile(
      tagline: d['tagline']?.toString() ?? firstLine(description),
      heroImageUrl: d['hero_image_url']?.toString() ?? '',
      address: d['address']?.toString() ?? 'One Exchange Square, London',
      contactEmail: d['contact_email']?.toString() ??
          'institutional@$slug.example.com',
      displayDomain: d['display_domain']?.toString() ?? host(website),
      regulationTitle: d['regulation_title']?.toString() ?? 'SEC & FCA Regulated',
      regulationBody: d['regulation_body']?.toString() ??
          'Dual oversight across major jurisdictions with segregated client assets.',
      executionTitle: d['execution_title']?.toString() ?? '12ms Execution',
      executionBody: d['execution_body']?.toString() ??
          'Low-latency routing with smart order placement across tier-one venues.',
      metricAum: d['metric_aum']?.toString() ?? '+24.8%',
      metricLiquidity: d['metric_liquidity']?.toString() ?? '\$12.4B',
      metricRetention: d['metric_retention']?.toString() ?? '98.2%',
      prospectusUrl: d['prospectus_url']?.toString() ?? website,
      markets: marketsFrom(d),
    );
  }

  static List<MarketStat> _defaultMarkets(String brokerType) {
    final crypto = brokerType == 'crypto' ? '120+' : '5';
    return [
      const MarketStat(label: 'FOREX PAIRS', value: '80+'),
      const MarketStat(label: 'INDICES', value: '25'),
      const MarketStat(label: 'COMMODITIES', value: '18'),
      const MarketStat(label: 'EQUITIES', value: '4,000+'),
      const MarketStat(label: 'SOVEREIGN BONDS', value: '12'),
      MarketStat(label: 'CRYPTO ETPS', value: crypto),
    ];
  }
}

class Broker {
  final int id;
  final String name;
  final String slug;
  final String description;
  final String logoUrl;
  final String website;
  final String brokerType;
  final BrokerProfile profile;

  Broker({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.logoUrl,
    required this.website,
    required this.brokerType,
    required this.profile,
  });
}
