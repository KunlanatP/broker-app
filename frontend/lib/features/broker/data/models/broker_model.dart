import 'package:json_annotation/json_annotation.dart';

part 'broker_model.g.dart';

@JsonSerializable()
class BrokerModel {
  final int id;
  final String name;
  final String slug;
  final String description;

  @JsonKey(name: 'logo_url')
  final String logoUrl;

  final String website;

  @JsonKey(name: 'broker_type')
  final String brokerType;

  BrokerModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.logoUrl,
    required this.website,
    required this.brokerType,
  });

  factory BrokerModel.fromJson(Map<String, dynamic> json) =>
      _$BrokerModelFromJson(json);

  Map<String, dynamic> toJson() => _$BrokerModelToJson(this);
}