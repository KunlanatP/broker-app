import 'package:equatable/equatable.dart';

abstract class BrokerCreateEvent extends Equatable {
  const BrokerCreateEvent();

  @override
  List<Object?> get props => [];
}

class BrokerCreateSubmitted extends BrokerCreateEvent {
  final String name;
  final String slug;
  final String description;
  final String logoUrl;
  final String website;
  final String brokerType;

  const BrokerCreateSubmitted({
    required this.name,
    required this.slug,
    required this.description,
    required this.logoUrl,
    required this.website,
    required this.brokerType,
  });

  @override
  List<Object?> get props => [
    name,
    slug,
    description,
    logoUrl,
    website,
    brokerType,
  ];
}
