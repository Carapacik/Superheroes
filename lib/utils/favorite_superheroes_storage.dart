import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:superheroes/model/superhero.dart';

class FavoriteSuperheroesStorage {
  FavoriteSuperheroesStorage._internal();

  factory FavoriteSuperheroesStorage.getInstance() =>
      _instance ??= FavoriteSuperheroesStorage._internal();

  static FavoriteSuperheroesStorage? _instance;

  static const _key = 'favorite_superheroes';

  // ignore: prefer_void_to_null
  final updater = PublishSubject<Null>();

  Future<bool> addToFavorites(final Superhero superhero) async {
    final rawSuperheroes = await _getRawSuperheroes();
    rawSuperheroes.add(json.encode(superhero.toJson()));
    return _setRawSuperheroes(rawSuperheroes);
  }

  Future<bool> removeFromFavorites(final int id) async {
    final superheroes = await _getSuperheroes();
    superheroes.removeWhere((superhero) => superhero.id == id);
    return _setSuperheroes(superheroes);
  }

  Future<List<String>> _getRawSuperheroes() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getStringList(_key) ?? [];
  }

  Future<bool> _setRawSuperheroes(final List<String> rawSuperheroes) async {
    final sp = await SharedPreferences.getInstance();
    final result = sp.setStringList(_key, rawSuperheroes);
    updater.add(null);
    return result;
  }

  Future<List<Superhero>> _getSuperheroes() async {
    final rawSuperheroes = await _getRawSuperheroes();
    return rawSuperheroes
        .map(
          (rawSuperhero) => Superhero.fromJson(
            json.decode(rawSuperhero) as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Future<bool> _setSuperheroes(final List<Superhero> superheroes) async {
    final rawSuperheroes = superheroes.map((superhero) => json.encode(superhero.toJson())).toList();
    return _setRawSuperheroes(rawSuperheroes);
  }

  Future<Superhero?> getSuperhero(final int id) async {
    final superheroes = await _getSuperheroes();
    for (final superhero in superheroes) {
      if (superhero.id == id) {
        return superhero;
      }
    }
    return null;
  }

  Stream<List<Superhero>> observeFavoriteSuperheroes() async* {
    yield await _getSuperheroes();
    // ignore: no_leading_underscores_for_local_identifiers
    await for (final _ in updater) {
      yield await _getSuperheroes();
    }
  }

  Stream<bool> observeIsFavorite(final int id) => observeFavoriteSuperheroes()
      .map((superheroes) => superheroes.any((element) => element.id == id));

  Future<bool> updateIfInFavorites(final Superhero newSuperhero) async {
    final superheroes = await _getSuperheroes();
    final index = superheroes.indexWhere((superhero) => superhero.id == newSuperhero.id);
    if (index == -1) {
      return false;
    }
    superheroes[index] = newSuperhero;
    return _setSuperheroes(superheroes);
  }
}
