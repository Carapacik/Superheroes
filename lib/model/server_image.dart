import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'server_image.g.dart';

@JsonSerializable()
@immutable
class ServerImage {
  const ServerImage(this.url);

  factory ServerImage.fromJson(Map<String, dynamic> json) =>
      _$ServerImageFromJson(json);

  final String url;

  Map<String, dynamic> toJson() => _$ServerImageToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServerImage &&
          runtimeType == other.runtimeType &&
          url == other.url;

  @override
  int get hashCode => url.hashCode;

  @override
  String toString() => 'ServerImage{url: $url}';
}
