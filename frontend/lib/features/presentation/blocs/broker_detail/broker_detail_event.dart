import 'package:equatable/equatable.dart';

abstract class BrokerDetailEvent extends Equatable {
  const BrokerDetailEvent();

  @override
  List<Object?> get props => [];
}

class BrokerDetailFetched extends BrokerDetailEvent {
  final String slug;

  const BrokerDetailFetched(this.slug);

  @override
  List<Object?> get props => [slug];
}
