import '../../domain/entities/broker.dart';
import '../../domain/repositories/broker_repository.dart';
import '../datasources/broker_api.dart';

class BrokerRepositoryImpl implements BrokerRepository {
  final BrokerApi api;

  BrokerRepositoryImpl(this.api);

  @override
  Future<List<Broker>> getBrokers({
    String? search,
    String? type,
  }) async {
    final models = await api.getBrokers(search: search, type: type);

    return models
        .map(
          (e) => Broker(
            id: e.id,
            name: e.name,
            slug: e.slug,
            description: e.description,
            logoUrl: e.logoUrl,
            website: e.website,
            brokerType: e.brokerType,
          ),
        )
        .toList();
  }

  @override
  Future<Broker> getBrokerBySlug(String slug) async {
    final e = await api.getBrokerBySlug(slug);

    return Broker(
      id: e.id,
      name: e.name,
      slug: e.slug,
      description: e.description,
      logoUrl: e.logoUrl,
      website: e.website,
      brokerType: e.brokerType,
    );
  }

  @override
  Future<void> createBroker({
    required String name,
    required String slug,
    required String description,
    required String logoUrl,
    required String website,
    required String brokerType,
  }) {
    return api.createBroker(
      name: name,
      slug: slug,
      description: description,
      logoUrl: logoUrl,
      website: website,
      brokerType: brokerType,
    );
  }
}