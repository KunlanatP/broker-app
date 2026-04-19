import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/network/dio_client.dart';
import '../../features/broker/data/datasources/broker_api.dart';
import '../../features/broker/data/repositories/broker_repository_impl.dart';
import '../../features/presentation/blocs/broker_create/broker_create_bloc.dart';
import '../../features/presentation/blocs/broker_detail/broker_detail_bloc.dart';
import '../../features/presentation/blocs/broker_list/broker_list_bloc.dart';
import '../../features/presentation/pages/broker_create_page.dart';
import '../../features/presentation/pages/broker_detail_page.dart';
import '../../features/presentation/pages/broker_list_page.dart';

class AppRouter {
  static final Dio _dio = DioClient.instance;
  static final BrokerApi _brokerApi = BrokerApi(_dio);
  static final BrokerRepositoryImpl _brokerRepository = BrokerRepositoryImpl(
    _brokerApi,
  );

  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          return BlocProvider(
            create: (_) => BrokerListBloc(_brokerRepository),
            child: const BrokerListPage(),
          );
        },
      ),
      GoRoute(
        path: '/create',
        builder: (context, state) {
          return BlocProvider(
            create: (_) => BrokerCreateBloc(_brokerRepository),
            child: const BrokerCreatePage(),
          );
        },
      ),
      GoRoute(
        path: '/broker/:slug',
        builder: (context, state) {
          final slug = state.pathParameters['slug'] ?? '';

          return BlocProvider(
            create: (_) => BrokerDetailBloc(_brokerRepository),
            child: BrokerDetailPage(slug: slug),
          );
        },
      ),
    ],
  );
}
