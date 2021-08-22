import 'package:json_annotation/json_annotation.dart';
import 'package:superheroes/model/alignment_info.dart';

part 'biography.g.dart';

@JsonSerializable()
class Biography {
  final String fullName;
  final String alignment;
  final List<String> aliases;
  final String placeOfBirth;

  Biography({
    required this.aliases,
    required this.alignment,
    required this.fullName,
    required this.placeOfBirth,
  });

  AlignmentInfo? get alignmentInfo => AlignmentInfo.fromAlignment(alignment);

  factory Biography.fromJson(Map<String, dynamic> json) => _$BiographyFromJson(json);

  Map<String, dynamic> toJson() => _$BiographyToJson(this);
}
