import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:superheroes/model/alignment.dart';

part 'biography.g.dart';

@JsonSerializable()
@immutable
class Biography {
  const Biography({
    required this.aliases,
    required this.alignmentEnum,
    required this.fullName,
    required this.placeOfBirth,
    this.publisher,
  });

  factory Biography.fromJson(Map<String, dynamic> json) => _$BiographyFromJson(json);

  final String fullName;
  final AlignmentEnum? alignmentEnum;
  final List<String> aliases;
  final String placeOfBirth;
  final String? publisher;

  Map<String, dynamic> toJson() => _$BiographyToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Biography &&
          runtimeType == other.runtimeType &&
          fullName == other.fullName &&
          alignmentEnum == other.alignmentEnum &&
          const ListEquality<String>().equals(aliases, other.aliases) &&
          placeOfBirth == other.placeOfBirth &&
          publisher == other.publisher;

  @override
  int get hashCode =>
      fullName.hashCode ^
      alignmentEnum.hashCode ^
      aliases.hashCode ^
      placeOfBirth.hashCode ^
      publisher.hashCode;
}
