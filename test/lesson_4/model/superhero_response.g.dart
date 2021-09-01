// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'superhero_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SuperheroResponse _$SuperheroResponseFromJson(Map<String, dynamic> json) {
  return SuperheroResponse(
    response: json['response'] as String,
    error: json['error'] as String?,
    id: json['id'] as String?,
    name: json['name'] as String?,
    biography: json['biography'] == null
        ? null
        : Biography.fromJson(json['biography'] as Map<String, dynamic>),
    image: json['image'] == null
        ? null
        : ServerImage.fromJson(json['image'] as Map<String, dynamic>),
    powerstats: json['powerstats'] == null
        ? null
        : Powerstats.fromJson(json['powerstats'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$SuperheroResponseToJson(SuperheroResponse instance) =>
    <String, dynamic>{
      'response': instance.response,
      'error': instance.error,
      'id': instance.id,
      'name': instance.name,
      'biography': instance.biography?.toJson(),
      'image': instance.image?.toJson(),
      'powerstats': instance.powerstats?.toJson(),
    };
