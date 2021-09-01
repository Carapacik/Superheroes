// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResponse _$SearchResponseFromJson(Map<String, dynamic> json) {
  return SearchResponse(
    result: json['result'] as String,
    error: json['error'] as String?,
    results: (json['results'] as List<dynamic>?)
        ?.map((e) => Superhero.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$SearchResponseToJson(SearchResponse instance) =>
    <String, dynamic>{
      'result': instance.result,
      'error': instance.error,
      'results': instance.results?.map((e) => e.toJson()).toList(),
    };
