import 'package:json_annotation/json_annotation.dart';
import 'package:superheroes/model/biography.dart';
import 'package:superheroes/model/server_image.dart';

part 'superhero.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class Superhero {
  final String name;
  final Biography biography;
  final ServerImage image;

  Superhero(this.name, this.biography, this.image);

  factory Superhero.fromJson(Map<String, dynamic> json) =>
      _$SuperheroFromJson(json);

  Map<String, dynamic> toJson() => _$SuperheroToJson(this);
}
