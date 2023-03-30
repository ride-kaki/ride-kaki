import 'package:json_annotation/json_annotation.dart';

part "waypoints.g.dart";

@JsonSerializable()
class WayPoints{
  String? starting_latitude;
  String? starting_longitude;
  String? ending_latitude;
  String? ending_longitude;

  WayPoints({required this.starting_latitude, required this.starting_longitude,required this.ending_latitude, required this.ending_longitude});

  factory WayPoints.fromJson(Map<String, dynamic> json) =>
      _$WayPointsFromJson(json);

  Map<String, dynamic> toJson() => _$WayPointsToJson(this);
}