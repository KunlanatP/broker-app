import 'package:frontend/features/broker/domain/entities/broker.dart';
import 'package:frontend/features/broker/domain/repositories/broker_repository.dart';

class FakeBrokerRepository implements BrokerRepository {
  List<Broker> brokers = const [];
  Broker? brokerBySlug;
  Object? listError;
  Object? detailError;
  Object? createError;

  String? lastSearch;
  String? lastType;
  String? lastCreateName;
  String? lastCreateSlug;
  String? lastCreateDescription;
  String? lastCreateLogoUrl;
  String? lastCreateWebsite;
  String? lastCreateBrokerType;

  @override
  Future<List<Broker>> getBrokers({String? search, String? type}) async {
    lastSearch = search;
    lastType = type;
    if (listError != null) throw listError!;
    return brokers;
  }

  @override
  Future<Broker> getBrokerBySlug(String slug) async {
    if (detailError != null) throw detailError!;
    if (brokerBySlug == null) throw StateError('missing stub broker');
    return brokerBySlug!;
  }

  @override
  Future<void> createBroker({
    required String name,
    required String slug,
    required String description,
    required String logoUrl,
    required String website,
    required String brokerType,
  }) async {
    lastCreateName = name;
    lastCreateSlug = slug;
    lastCreateDescription = description;
    lastCreateLogoUrl = logoUrl;
    lastCreateWebsite = website;
    lastCreateBrokerType = brokerType;
    if (createError != null) throw createError!;
  }
}

