import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/presentation/blocs/broker_create/broker_create_bloc.dart';
import 'package:frontend/features/presentation/blocs/broker_create/broker_create_event.dart';
import 'package:frontend/features/presentation/blocs/broker_create/broker_create_state.dart';

import '../fakes/fake_broker_repository.dart';

void main() {
  blocTest<BrokerCreateBloc, BrokerCreateState>(
    'emits loading then success and forwards payload',
    build: () => BrokerCreateBloc(FakeBrokerRepository()),
    act: (bloc) => bloc.add(
      const BrokerCreateSubmitted(
        name: 'Blackwood Capital Markets',
        slug: 'blackwood-capital-markets',
        description: 'd',
        logoUrl: 'https://example.com/logo.png',
        website: 'https://blackwood-capital.com',
        brokerType: 'stock',
      ),
    ),
    expect: () => [
      isA<BrokerCreateState>().having((s) => s.status, 'status', BrokerCreateStatus.loading),
      isA<BrokerCreateState>().having((s) => s.status, 'status', BrokerCreateStatus.success),
    ],
    verify: (bloc) {
      final repo = (bloc.repository as FakeBrokerRepository);
      expect(repo.lastCreateSlug, 'blackwood-capital-markets');
      expect(repo.lastCreateBrokerType, 'stock');
    },
  );

  blocTest<BrokerCreateBloc, BrokerCreateState>(
    'emits failure when repo throws',
    build: () {
      final repo = FakeBrokerRepository()..createError = Exception('boom');
      return BrokerCreateBloc(repo);
    },
    act: (bloc) => bloc.add(
      const BrokerCreateSubmitted(
        name: 'A',
        slug: 'a',
        description: 'd',
        logoUrl: 'https://example.com/logo.png',
        website: 'https://a.com',
        brokerType: 'cfd',
      ),
    ),
    expect: () => [
      isA<BrokerCreateState>().having((s) => s.status, 'status', BrokerCreateStatus.loading),
      isA<BrokerCreateState>().having((s) => s.status, 'status', BrokerCreateStatus.failure),
    ],
  );
}

