import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../broker/domain/repositories/broker_repository.dart';
import 'broker_detail_event.dart';
import 'broker_detail_state.dart';

class BrokerDetailBloc extends Bloc<BrokerDetailEvent, BrokerDetailState> {
  final BrokerRepository repository;

  BrokerDetailBloc(this.repository) : super(const BrokerDetailState()) {
    on<BrokerDetailFetched>(_onFetched);
  }

  Future<void> _onFetched(
    BrokerDetailFetched event,
    Emitter<BrokerDetailState> emit,
  ) async {
    emit(state.copyWith(status: BrokerDetailStatus.loading));

    try {
      final broker = await repository.getBrokerBySlug(event.slug);
      emit(state.copyWith(status: BrokerDetailStatus.success, broker: broker));
    } catch (e) {
      emit(
        state.copyWith(
          status: BrokerDetailStatus.failure,
          message: e.toString(),
        ),
      );
    }
  }
}
