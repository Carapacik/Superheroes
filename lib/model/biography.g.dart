// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'biography.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Biography _$BiographyFromJson(Map<String, dynamic> json) => Biography(
      aliases:
          (json['aliases'] as List<dynamic>).map((e) => e as String).toList(),
      alignment: json['alignment'] as String,
      fullName: json['fullName'] as String,
      placeOfBirth: json['placeOfBirth'] as String,
      publisher: json['publisher'] as String?,
    );

Map<String, dynamic> _$BiographyToJson(Biography instance) => <String, dynamic>{
      'fullName': instance.fullName,
      'alignment': instance.alignment,
      'aliases': instance.aliases,
      'placeOfBirth': instance.placeOfBirth,
      'publisher': instance.publisher,
    };
