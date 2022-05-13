import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:superheroes/model/alignment_info.dart';

part 'biography.g.dart';

@JsonSerializable()
@immutable
class Biography {
  const Biography({
    required this.aliases,
    required this.alignment,
    required this.fullName,
    required this.placeOfBirth,
  });

  factory Biography.fromJson(Map<String, dynamic> json) =>
      _$BiographyFromJson(json);

  final String fullName;
  final String alignment;
  final List<String> aliases;
  final String placeOfBirth;

  AlignmentInfo? get alignmentInfo => AlignmentInfo.fromAlignment(alignment);

  Map<String, dynamic> toJson() => _$BiographyToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Biography &&
          runtimeType == other.runtimeType &&
          fullName == other.fullName &&
          alignment == other.alignment &&
          const ListEquality<String>().equals(aliases, other.aliases) &&
          placeOfBirth == other.placeOfBirth;

  @override
  int get hashCode =>
      fullName.hashCode ^
      alignment.hashCode ^
      aliases.hashCode ^
      placeOfBirth.hashCode;

  @override
  String toString() =>
      'Biography{fullName: $fullName, alignment: $alignment, aliases: $aliases, placeOfBirth: $placeOfBirth}';
}
