import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:superheroes/exception/api_exception.dart';
import 'package:superheroes/favorite_superheroes_storage.dart';
import 'package:superheroes/model/superhero.dart';
import 'package:superheroes/resources/constants.dart';

class SuperheroBloc {
  SuperheroBloc({
    required this.id,
    this.client,
  }) {
    getFromFavorites();
  }

  http.Client? client;
  final String id;

  final superheroPageStateSubject = BehaviorSubject<SuperheroPageState>();
  final superheroSubject = BehaviorSubject<Superhero>();
  StreamSubscription? getFromFavoritesSubscription;
  StreamSubscription? requestSubscription;
  StreamSubscription? addToFavoriteSubscription;
  StreamSubscription? removeFromFavoriteSubscription;

  void getFromFavorites() {
    getFromFavoritesSubscription?.cancel();
    getFromFavoritesSubscription = FavoriteSuperheroesStorage.getInstance()
        .getSuperhero(id)
        .asStream()
        .listen(
      (superhero) {
        if (superhero != null) {
          superheroSubject.add(superhero);
          superheroPageStateSubject.add(SuperheroPageState.loaded);
        } else {
          superheroPageStateSubject.add(SuperheroPageState.loading);
        }
        requestSuperhero(isInFavorite: superhero != null);
      },
      onError: (Object error) {
        superheroPageStateSubject.add(SuperheroPageState.error);
      },
    );
  }

  void addToFavorite() {
    final superhero = superheroSubject.valueOrNull;
    if (superhero == null) {
      return;
    }
    addToFavoriteSubscription?.cancel();
    addToFavoriteSubscription = FavoriteSuperheroesStorage.getInstance()
        .addToFavorites(superhero)
        .asStream()
        .listen(
          (event) => superheroPageStateSubject.add(SuperheroPageState.loaded),
        );
  }

  void removeFromFavorites() {
    removeFromFavoriteSubscription?.cancel();
    removeFromFavoriteSubscription = FavoriteSuperheroesStorage.getInstance()
        .removeFromFavorites(id)
        .asStream()
        .listen(
          (event) {},
        );
  }

  void requestSuperhero({required final bool isInFavorite}) {
    requestSubscription?.cancel();
    requestSubscription = request().asStream().listen(
      (superhero) {
        superheroSubject.add(superhero);
        superheroPageStateSubject.add(SuperheroPageState.loaded);
      },
      onError: (Object error) {
        if (!isInFavorite) {
          superheroPageStateSubject.add(SuperheroPageState.error);
        }
      },
    );
  }

  void retry() {
    superheroPageStateSubject.add(SuperheroPageState.loading);
    requestSuperhero(isInFavorite: false);
  }

  Future<Superhero> request() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final response = await (client ??= http.Client())
        .get(Uri.parse('https://superheroapi.com/api/$token/$id'));
    if (response.statusCode >= 500 && response.statusCode <= 599) {
      throw const ApiException('Server error happened');
    }
    if (response.statusCode >= 400 && response.statusCode <= 499) {
      throw const ApiException('Client error happened');
    }
    final decoded = json.decode(response.body) as Map<String, dynamic>;
    if (decoded['response'] == 'success') {
      final superhero = Superhero.fromJson(decoded);
      await FavoriteSuperheroesStorage.getInstance()
          .updateIfInFavorites(superhero);
      return superhero;
    } else if (decoded['response'] == 'error') {
      throw const ApiException('Client error happened');
    }
    throw Exception('Unknown error happened');
  }

  Stream<bool> observeIsFavorite() =>
      FavoriteSuperheroesStorage.getInstance().observeIsFavorite(id);

  Stream<Superhero> observeSuperhero() => superheroSubject.distinct();

  Stream<SuperheroPageState> observeSuperheroPageState() =>
      superheroPageStateSubject.distinct();

  void dispose() {
    client?.close();
    getFromFavoritesSubscription?.cancel();
    requestSubscription?.cancel();
    addToFavoriteSubscription?.cancel();
    removeFromFavoriteSubscription?.cancel();
    superheroSubject.close();
    superheroPageStateSubject.close();
  }
}

enum SuperheroPageState { loading, loaded, error }
