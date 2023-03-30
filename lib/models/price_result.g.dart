// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PriceResult _$PriceResultFromJson(Map<String, dynamic> json) => PriceResult(
      gojek_4_economy_price:
          (json['gojek_4_economy_price'] as num?)?.toDouble(),
      gojek_6_economy_price:
          (json['gojek_6_economy_price'] as num?)?.toDouble(),
      gojek_4_premium_price:
          (json['gojek_4_premium_price'] as num?)?.toDouble(),
      tada_4_economy_price: (json['tada_4_economy_price'] as num?)?.toDouble(),
      tada_6_economy_price: (json['tada_6_economy_price'] as num?)?.toDouble(),
      tada_4_premium_price: (json['tada_4_premium_price'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$PriceResultToJson(PriceResult instance) =>
    <String, dynamic>{
      'gojek_4_economy_price': instance.gojek_4_economy_price,
      'gojek_6_economy_price': instance.gojek_6_economy_price,
      'gojek_4_premium_price': instance.gojek_4_premium_price,
      'tada_4_economy_price': instance.tada_4_economy_price,
      'tada_6_economy_price': instance.tada_6_economy_price,
      'tada_4_premium_price': instance.tada_4_premium_price,
    };
