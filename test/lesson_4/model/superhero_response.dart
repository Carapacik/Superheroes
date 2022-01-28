import 'package:json_annotation/json_annotation.dart';
import 'package:superheroes/model/biography.dart';
import 'package:superheroes/model/powerstats.dart';
import 'package:superheroes/model/server_image.dart';

part 'superhero_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SuperheroResponse {
  final String response;
  final String? error;

  final String? id;
  final String? name;
  final Biography? biography;
  final ServerImage? image;
  final Powerstats? powerstats;

  factory SuperheroResponse.fromJson(final Map<String, dynamic> json) =>
      _$SuperheroResponseFromJson(json);

  SuperheroResponse({
    required this.response,
    this.error,
    this.id,
    this.name,
    this.biography,
    this.image,
    this.powerstats,
  });

  Map<String, dynamic> toJson() => _$SuperheroResponseToJson(this);
}
