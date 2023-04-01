import 'package:json_annotation/json_annotation.dart';

part "history.g.dart";

@JsonSerializable()
class History {
  @JsonKey(name: "user_id")
  final String userId;

  final String search;

  @JsonKey(name: "created_at", includeToJson: false)
  final DateTime? createdAt;

  History({
    required this.userId,
    required this.search,
    this.createdAt,
  });

  factory History.fromJson(Map<String, dynamic> json) =>
      _$HistoryFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryToJson(this);
}
