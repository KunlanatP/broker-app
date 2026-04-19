class Broker {
  final int id;
  final String name;
  final String slug;
  final String description;
  final String logoUrl;
  final String website;
  final String brokerType;

  Broker({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.logoUrl,
    required this.website,
    required this.brokerType,
  });
}