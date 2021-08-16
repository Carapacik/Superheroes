import 'package:json_annotation/json_annotation.dart';

part 'powerstats.g.dart';

@JsonSerializable(explicitToJson: true)
class Powerstats {
  final String intelligence;
  final String strength;
  final String speed;
  final String durability;
  final String power;
  final String combat;

  Powerstats({
    required this.intelligence,
    required this.strength,
    required this.speed,
    required this.durability,
    required this.power,
    required this.combat,
  });

  factory Powerstats.fromJson(Map<String, dynamic> json) => _$PowerstatsFromJson(json);

  Map<String, dynamic> toJson() => _$PowerstatsToJson(this);
}
