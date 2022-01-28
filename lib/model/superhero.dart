import 'package:json_annotation/json_annotation.dart';
import 'package:superheroes/model/biography.dart';
import 'package:superheroes/model/powerstats.dart';
import 'package:superheroes/model/server_image.dart';

part 'superhero.g.dart';

@JsonSerializable()
class Superhero {
  final String id;
  final String name;
  final Biography biography;
  final ServerImage image;
  final Powerstats powerstats;

  Superhero({
    required this.id,
    required this.name,
    required this.biography,
    required this.image,
    required this.powerstats,
  });

  factory Superhero.fromJson(Map<String, dynamic> json) =>
      _$SuperheroFromJson(json);

  Map<String, dynamic> toJson() => _$SuperheroToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Superhero &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              biography == other.biography &&
              image == other.image &&
              powerstats == other.powerstats;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      biography.hashCode ^
      image.hashCode ^
      powerstats.hashCode;

  @override
  String toString() {
    return 'Superhero{id: $id, name: $name, biography: $biography, image: $image, powerstats: $powerstats}';
  }
}
