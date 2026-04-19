import 'package:equatable/equatable.dart';

abstract class BrokerListEvent extends Equatable {
  const BrokerListEvent();

  @override
  List<Object?> get props => [];
}

class BrokerListFetched extends BrokerListEvent {
  final String? search;
  final String? type;

  const BrokerListFetched({
    this.search,
    this.type,
  });

  @override
  List<Object?> get props => [search, type];
}