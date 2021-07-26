// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'biography.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Biography _$BiographyFromJson(Map<String, dynamic> json) {
  return Biography(
    json['full-name'] as String,
    json['alignment'] as String,
  );
}

Map<String, dynamic> _$BiographyToJson(Biography instance) => <String, dynamic>{
      'full-name': instance.fullName,
      'alignment': instance.alignment,
    };
