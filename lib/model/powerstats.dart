import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'powerstats.g.dart';

@JsonSerializable()
@immutable
class Powerstats {
  const Powerstats({
    required this.intelligence,
    required this.strength,
    required this.speed,
    required this.durability,
    required this.power,
    required this.combat,
  });

  factory Powerstats.fromJson(Map<String, dynamic> json) =>
      _$PowerstatsFromJson(json);

  final int intelligence;
  final int strength;
  final int speed;
  final int durability;
  final int power;
  final int combat;

  double get intelligencePercent => convertStringToPercent(intelligence);

  double get strengthPercent => convertStringToPercent(strength);

  double get speedPercent => convertStringToPercent(speed);

  double get durabilityPercent => convertStringToPercent(durability);

  double get powerPercent => convertStringToPercent(power);

  double get combatPercent => convertStringToPercent(combat);

  double convertStringToPercent(final int value) {
    if (value < 0) {
      return 0;
    }
    return value / 100;
  }

  Map<String, dynamic> toJson() => _$PowerstatsToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Powerstats &&
          runtimeType == other.runtimeType &&
          intelligence == other.intelligence &&
          strength == other.strength &&
          speed == other.speed &&
          durability == other.durability &&
          power == other.power &&
          combat == other.combat;

  @override
  int get hashCode =>
      intelligence.hashCode ^
      strength.hashCode ^
      speed.hashCode ^
      durability.hashCode ^
      power.hashCode ^
      combat.hashCode;
}
