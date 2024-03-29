import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:superheroes/exception/api_exception.dart';
import 'package:superheroes/model/superhero.dart';
import 'package:superheroes/utils/constants.dart';
import 'package:superheroes/utils/favorite_superheroes_storage.dart';

// ignore_for_file: avoid_types_on_closure_parameters, discarded_futures, unawaited_futures
class SuperheroBloc {
  SuperheroBloc({required this.id, this.client}) {
    getFromFavorites();
  }

  http.Client? client;
  final int id;

  final superheroPageStateSubject = BehaviorSubject<SuperheroPageState>();
  final superheroSubject = BehaviorSubject<Superhero>();
  StreamSubscription<Superhero?>? getFromFavoritesSubscription;
  StreamSubscription<Superhero>? requestSubscription;
  StreamSubscription<bool>? addToFavoriteSubscription;
  StreamSubscription<bool>? removeFromFavoriteSubscription;

  void getFromFavorites() {
    getFromFavoritesSubscription?.cancel();
    getFromFavoritesSubscription =
        FavoriteSuperheroesStorage.getInstance().getSuperhero(id).asStream().listen(
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
    addToFavoriteSubscription =
        FavoriteSuperheroesStorage.getInstance().addToFavorites(superhero).asStream().listen(
              (event) => superheroPageStateSubject.add(SuperheroPageState.loaded),
            );
  }

  void removeFromFavorites() {
    removeFromFavoriteSubscription?.cancel();
    removeFromFavoriteSubscription =
        FavoriteSuperheroesStorage.getInstance().removeFromFavorites(id).asStream().listen(
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
    final response = await (client ??= http.Client()).get(
      Uri.parse('$baseUrl/id/$id.json'),
    );
    if (response.statusCode >= 500 && response.statusCode <= 599) {
      throw const ApiException('Server error happened');
    }
    if (response.statusCode >= 400 && response.statusCode <= 499) {
      throw const ApiException('Client error happened');
    }
    final decoded = json.decode(response.body) as Map<String, dynamic>;

    final superhero = Superhero.fromJson(decoded);
    await FavoriteSuperheroesStorage.getInstance().updateIfInFavorites(superhero);
    return superhero;
  }

  Stream<bool> observeIsFavorite() =>
      FavoriteSuperheroesStorage.getInstance().observeIsFavorite(id);

  Stream<Superhero> observeSuperhero() => superheroSubject.distinct();

  Stream<SuperheroPageState> observeSuperheroPageState() => superheroPageStateSubject.distinct();

  void dispose() {
    getFromFavoritesSubscription?.cancel();
    requestSubscription?.cancel();
    addToFavoriteSubscription?.cancel();
    removeFromFavoriteSubscription?.cancel();

    superheroSubject.close();
    superheroPageStateSubject.close();

    client?.close();
  }
}

enum SuperheroPageState { loading, loaded, error }
