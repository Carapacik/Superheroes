// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'superhero.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Superhero _$SuperheroFromJson(Map<String, dynamic> json) => Superhero(
      id: json['id'] as String,
      name: json['name'] as String,
      biography: Biography.fromJson(json['biography'] as Map<String, dynamic>),
      image: ServerImage.fromJson(json['image'] as Map<String, dynamic>),
      powerstats:
          Powerstats.fromJson(json['powerstats'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SuperheroToJson(Superhero instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'biography': instance.biography.toJson(),
      'image': instance.image.toJson(),
      'powerstats': instance.powerstats.toJson(),
    };
