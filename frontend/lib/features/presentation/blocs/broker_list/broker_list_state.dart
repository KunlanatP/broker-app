import 'package:equatable/equatable.dart';
import '../../../broker/domain/entities/broker.dart';

enum BrokerListStatus { initial, loading, success, failure }

class BrokerListState extends Equatable {
  final BrokerListStatus status;
  final List<Broker> brokers;
  final String message;
  final String search;
  final String type;

  const BrokerListState({
    this.status = BrokerListStatus.initial,
    this.brokers = const [],
    this.message = '',
    this.search = '',
    this.type = '',
  });

  BrokerListState copyWith({
    BrokerListStatus? status,
    List<Broker>? brokers,
    String? message,
    String? search,
    String? type,
  }) {
    return BrokerListState(
      status: status ?? this.status,
      brokers: brokers ?? this.brokers,
      message: message ?? this.message,
      search: search ?? this.search,
      type: type ?? this.type,
    );
  }

  @override
  List<Object?> get props => [status, brokers, message, search, type];
}
