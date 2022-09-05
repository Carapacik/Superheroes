// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'biography.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Biography _$BiographyFromJson(Map<String, dynamic> json) => Biography(
      aliases: (json['aliases'] as List<dynamic>).map((e) => e as String).toList(),
      alignmentEnum: $enumDecodeNullable(_$AlignmentEnumEnumMap, json['alignmentEnum']),
      fullName: json['fullName'] as String,
      placeOfBirth: json['placeOfBirth'] as String,
      publisher: json['publisher'] as String?,
    );

Map<String, dynamic> _$BiographyToJson(Biography instance) => <String, dynamic>{
      'fullName': instance.fullName,
      'alignmentEnum': _$AlignmentEnumEnumMap[instance.alignmentEnum],
      'aliases': instance.aliases,
      'placeOfBirth': instance.placeOfBirth,
      'publisher': instance.publisher,
    };

const _$AlignmentEnumEnumMap = {
  AlignmentEnum.bad: 'bad',
  AlignmentEnum.neutral: 'neutral',
  AlignmentEnum.good: 'good',
};
