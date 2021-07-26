import 'package:json_annotation/json_annotation.dart';

part 'biography.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class Biography {
  final String fullName;

  Biography(this.fullName);

  factory Biography.fromJson(Map<String, dynamic> json) =>
      _$BiographyFromJson(json);

  Map<String, dynamic> toJson() => _$BiographyToJson(this);
}
