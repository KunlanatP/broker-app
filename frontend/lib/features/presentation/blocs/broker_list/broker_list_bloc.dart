import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../broker/domain/repositories/broker_repository.dart';
import 'broker_list_event.dart';
import 'broker_list_state.dart';

class BrokerListBloc extends Bloc<BrokerListEvent, BrokerListState> {
  final BrokerRepository repository;

  BrokerListBloc(this.repository) : super(const BrokerListState()) {
    on<BrokerListFetched>(_onFetched);
  }

  Future<void> _onFetched(
    BrokerListFetched event,
    Emitter<BrokerListState> emit,
  ) async {
    emit(
      state.copyWith(
        status: BrokerListStatus.loading,
        search: event.search ?? '',
        type: event.type ?? '',
      ),
    );

    try {
      final brokers = await repository.getBrokers(
        search: event.search,
        type: event.type,
      );

      emit(state.copyWith(status: BrokerListStatus.success, brokers: brokers));
    } catch (e) {
      emit(
        state.copyWith(status: BrokerListStatus.failure, message: e.toString()),
      );
    }
  }
}
