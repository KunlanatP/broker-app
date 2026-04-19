part of 'broker_model.dart';

BrokerModel _$BrokerModelFromJson(Map<String, dynamic> json) => BrokerModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  slug: json['slug'] as String,
  description: json['description'] as String,
  logoUrl: json['logo_url'] as String,
  website: json['website'] as String,
  brokerType: json['broker_type'] as String,
  detail: json['detail'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$BrokerModelToJson(BrokerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'description': instance.description,
      'logo_url': instance.logoUrl,
      'website': instance.website,
      'broker_type': instance.brokerType,
      'detail': instance.detail,
    };
