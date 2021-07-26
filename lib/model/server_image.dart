import 'package:json_annotation/json_annotation.dart';

part 'server_image.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab, explicitToJson: true)
class ServerImage {
  final String url;

  ServerImage(this.url);

  factory ServerImage.fromJson(Map<String, dynamic> json) =>
      _$ServerImageFromJson(json);

  Map<String, dynamic> toJson() => _$ServerImageToJson(this);
}
