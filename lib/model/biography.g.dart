// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'biography.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Biography _$BiographyFromJson(Map<String, dynamic> json) => Biography(
      aliases:
          (json['aliases'] as List<dynamic>).map((e) => e as String).toList(),
      alignment: json['alignment'] as String,
      fullName: json['full-name'] as String,
      placeOfBirth: json['place-of-birth'] as String,
    );

Map<String, dynamic> _$BiographyToJson(Biography instance) => <String, dynamic>{
      'full-name': instance.fullName,
      'alignment': instance.alignment,
      'aliases': instance.aliases,
      'place-of-birth': instance.placeOfBirth,
    };
