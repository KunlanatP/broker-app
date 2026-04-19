import 'package:dio/dio.dart';
import '../../../../core/network/api_exception.dart';
import '../models/broker_model.dart';

class BrokerApi {
  final Dio dio;

  BrokerApi(this.dio);

  Future<List<BrokerModel>> getBrokers({
    String? search,
    String? type,
  }) async {
    try {
      final response = await dio.get(
        '/brokers',
        queryParameters: {
          if (search != null && search.isNotEmpty) 'search': search,
          if (type != null && type.isNotEmpty) 'type': type,
        },
      );

      final List<dynamic> data = response.data['data'];
      return data.map((e) => BrokerModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw ApiException(e.response?.data?['message'] ?? 'Failed to fetch brokers');
    }
  }

  Future<BrokerModel> getBrokerBySlug(String slug) async {
    try {
      final response = await dio.get('/brokers/$slug');
      return BrokerModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiException(e.response?.data?['message'] ?? 'Failed to fetch broker');
    }
  }

  Future<void> createBroker({
    required String name,
    required String slug,
    required String description,
    required String logoUrl,
    required String website,
    required String brokerType,
  }) async {
    try {
      await dio.post(
        '/brokers',
        data: {
          'name': name,
          'slug': slug,
          'description': description,
          'logo_url': logoUrl,
          'website': website,
          'broker_type': brokerType,
        },
      );
    } on DioException catch (e) {
      throw ApiException(e.response?.data?['message'] ?? 'Failed to create broker');
    }
  }
}