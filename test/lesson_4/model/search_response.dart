import 'package:json_annotation/json_annotation.dart';
import 'package:superheroes/model/superhero.dart';

part 'search_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SearchResponse {
  final String result;
  final String? error;
  final List<Superhero>? results;

  factory SearchResponse.fromJson(final Map<String, dynamic> json) =>
      _$SearchResponseFromJson(json);

  SearchResponse({required this.result, this.error, this.results});

  Map<String, dynamic> toJson() => _$SearchResponseToJson(this);
}
