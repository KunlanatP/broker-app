import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/presentation/blocs/broker_list/broker_list_bloc.dart';
import 'package:frontend/features/presentation/blocs/broker_list/broker_list_event.dart';
import 'package:frontend/features/presentation/blocs/broker_list/broker_list_state.dart';

import '../fakes/fake_broker_repository.dart';
import 'samples.dart';

void main() {
  blocTest<BrokerListBloc, BrokerListState>(
    'emits loading then success and forwards query params',
    build: () {
      final repo = FakeBrokerRepository()..brokers = [sampleBroker()];
      return BrokerListBloc(repo);
    },
    act: (bloc) => bloc.add(const BrokerListFetched(search: 'black', type: 'stock')),
    expect: () => [
      isA<BrokerListState>()
          .having((s) => s.status, 'status', BrokerListStatus.loading)
          .having((s) => s.search, 'search', 'black')
          .having((s) => s.type, 'type', 'stock'),
      isA<BrokerListState>()
          .having((s) => s.status, 'status', BrokerListStatus.success)
          .having((s) => s.brokers.length, 'len', 1),
    ],
    verify: (bloc) {
      final repo = (bloc.repository as FakeBrokerRepository);
      expect(repo.lastSearch, 'black');
      expect(repo.lastType, 'stock');
    },
  );

  blocTest<BrokerListBloc, BrokerListState>(
    'emits failure when repo throws',
    build: () {
      final repo = FakeBrokerRepository()..listError = Exception('boom');
      return BrokerListBloc(repo);
    },
    act: (bloc) => bloc.add(const BrokerListFetched()),
    expect: () => [
      isA<BrokerListState>().having((s) => s.status, 'status', BrokerListStatus.loading),
      isA<BrokerListState>().having((s) => s.status, 'status', BrokerListStatus.failure),
    ],
  );
}

