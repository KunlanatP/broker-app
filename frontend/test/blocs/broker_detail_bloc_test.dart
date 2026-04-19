import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/presentation/blocs/broker_detail/broker_detail_bloc.dart';
import 'package:frontend/features/presentation/blocs/broker_detail/broker_detail_event.dart';
import 'package:frontend/features/presentation/blocs/broker_detail/broker_detail_state.dart';

import '../fakes/fake_broker_repository.dart';
import 'samples.dart';

void main() {
  blocTest<BrokerDetailBloc, BrokerDetailState>(
    'emits loading then success',
    build: () {
      final repo = FakeBrokerRepository()..brokerBySlug = sampleBroker();
      return BrokerDetailBloc(repo);
    },
    act: (bloc) => bloc.add(const BrokerDetailFetched('blackwood-capital-markets')),
    expect: () => [
      isA<BrokerDetailState>().having((s) => s.status, 'status', BrokerDetailStatus.loading),
      isA<BrokerDetailState>()
          .having((s) => s.status, 'status', BrokerDetailStatus.success)
          .having((s) => s.broker?.slug, 'slug', 'blackwood-capital-markets'),
    ],
  );

  blocTest<BrokerDetailBloc, BrokerDetailState>(
    'emits failure when repo throws',
    build: () {
      final repo = FakeBrokerRepository()..detailError = Exception('boom');
      return BrokerDetailBloc(repo);
    },
    act: (bloc) => bloc.add(const BrokerDetailFetched('x')),
    expect: () => [
      isA<BrokerDetailState>().having((s) => s.status, 'status', BrokerDetailStatus.loading),
      isA<BrokerDetailState>().having((s) => s.status, 'status', BrokerDetailStatus.failure),
    ],
  );
}

