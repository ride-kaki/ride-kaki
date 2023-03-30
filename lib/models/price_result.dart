import 'package:json_annotation/json_annotation.dart';

part "price_result.g.dart";

@JsonSerializable()
class PriceResult {
  double? gojek_4_economy_price;
  double? gojek_6_economy_price;
  double? gojek_4_premium_price;
  double? tada_4_economy_price;
  double? tada_6_economy_price;
  double? tada_4_premium_price;


  PriceResult({required this.gojek_4_economy_price, required this.gojek_6_economy_price, required this.gojek_4_premium_price, required this.tada_4_economy_price, required this.tada_6_economy_price, required this.tada_4_premium_price});

  factory PriceResult.fromJson(Map<String, dynamic> json) =>
      _$PriceResultFromJson(json);

  Map<String, dynamic> toJson() => _$PriceResultToJson(this);
}