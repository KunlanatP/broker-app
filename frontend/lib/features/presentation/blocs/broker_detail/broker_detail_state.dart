import 'package:equatable/equatable.dart';

import '../../../broker/domain/entities/broker.dart';

enum BrokerDetailStatus { initial, loading, success, failure }

class BrokerDetailState extends Equatable {
  final BrokerDetailStatus status;
  final Broker? broker;
  final String message;

  const BrokerDetailState({
    this.status = BrokerDetailStatus.initial,
    this.broker,
    this.message = '',
  });

  BrokerDetailState copyWith({
    BrokerDetailStatus? status,
    Broker? broker,
    String? message,
  }) {
    return BrokerDetailState(
      status: status ?? this.status,
      broker: broker ?? this.broker,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, broker, message];
}