import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'server_images.g.dart';

@JsonSerializable()
@immutable
class ServerImages {
  const ServerImages(this.lg);

  factory ServerImages.fromJson(Map<String, dynamic> json) =>
      _$ServerImagesFromJson(json);

  final String lg;

  Map<String, dynamic> toJson() => _$ServerImagesToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServerImages &&
          runtimeType == other.runtimeType &&
          lg == other.lg;

  @override
  int get hashCode => lg.hashCode;
}
