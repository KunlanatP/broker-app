import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../broker/domain/repositories/broker_repository.dart';
import 'broker_create_event.dart';
import 'broker_create_state.dart';

class BrokerCreateBloc extends Bloc<BrokerCreateEvent, BrokerCreateState> {
  final BrokerRepository repository;

  BrokerCreateBloc(this.repository) : super(const BrokerCreateState()) {
    on<BrokerCreateSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    BrokerCreateSubmitted event,
    Emitter<BrokerCreateState> emit,
  ) async {
    emit(state.copyWith(status: BrokerCreateStatus.loading));

    try {
      await repository.createBroker(
        name: event.name,
        slug: event.slug,
        description: event.description,
        logoUrl: event.logoUrl,
        website: event.website,
        brokerType: event.brokerType,
      );

      emit(state.copyWith(status: BrokerCreateStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: BrokerCreateStatus.failure,
          message: e.toString(),
        ),
      );
    }
  }
}
