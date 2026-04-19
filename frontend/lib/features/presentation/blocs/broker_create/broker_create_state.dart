import 'package:equatable/equatable.dart';

enum BrokerCreateStatus { initial, loading, success, failure }

class BrokerCreateState extends Equatable {
  final BrokerCreateStatus status;
  final String message;

  const BrokerCreateState({
    this.status = BrokerCreateStatus.initial,
    this.message = '',
  });

  BrokerCreateState copyWith({BrokerCreateStatus? status, String? message}) {
    return BrokerCreateState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, message];
}
