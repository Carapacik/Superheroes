// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'superhero.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Superhero _$SuperheroFromJson(Map<String, dynamic> json) {
  return Superhero(
    json['name'] as String,
    Biography.fromJson(json['biography'] as Map<String, dynamic>),
    ServerImage.fromJson(json['image'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$SuperheroToJson(Superhero instance) => <String, dynamic>{
      'name': instance.name,
      'biography': instance.biography,
      'image': instance.image,
    };
