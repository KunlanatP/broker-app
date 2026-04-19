import '../entities/broker.dart';

abstract class BrokerRepository {
  Future<List<Broker>> getBrokers({
    String? search,
    String? type,
  });

  Future<Broker> getBrokerBySlug(String slug);

  Future<void> createBroker({
    required String name,
    required String slug,
    required String description,
    required String logoUrl,
    required String website,
    required String brokerType,
  });
}