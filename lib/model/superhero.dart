import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:superheroes/model/biography.dart';
import 'package:superheroes/model/powerstats.dart';
import 'package:superheroes/model/server_images.dart';

part 'superhero.g.dart';

@JsonSerializable()
@immutable
class Superhero {
  const Superhero({
    required this.id,
    required this.name,
    required this.biography,
    required this.images,
    required this.powerstats,
  });

  factory Superhero.fromJson(Map<String, dynamic> json) =>
      _$SuperheroFromJson(json);

  final int id;
  final String name;
  final Biography biography;
  final ServerImages images;
  final Powerstats powerstats;

  Map<String, dynamic> toJson() => _$SuperheroToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Superhero &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          biography == other.biography &&
          images == other.images &&
          powerstats == other.powerstats;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      biography.hashCode ^
      images.hashCode ^
      powerstats.hashCode;
}
