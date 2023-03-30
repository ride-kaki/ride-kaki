// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'waypoints.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WayPoints _$WayPointsFromJson(Map<String, dynamic> json) => WayPoints(
      starting_latitude: json['starting_latitude'] as String?,
      starting_longitude: json['starting_longitude'] as String?,
      ending_latitude: json['ending_latitude'] as String?,
      ending_longitude: json['ending_longitude'] as String?,
    );

Map<String, dynamic> _$WayPointsToJson(WayPoints instance) => <String, dynamic>{
      'starting_latitude': instance.starting_latitude,
      'starting_longitude': instance.starting_longitude,
      'ending_latitude': instance.ending_latitude,
      'ending_longitude': instance.ending_longitude,
    };
