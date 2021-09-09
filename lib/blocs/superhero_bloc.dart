import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:superheroes/exception/api_exception.dart';
import 'package:superheroes/favorite_superheroes_storage.dart';
import 'package:superheroes/model/superhero.dart';

class SuperheroBloc {
  http.Client? client;
  final String id;

  final superheroPageStateSubject = BehaviorSubject<SuperheroPageState>();
  final superheroSubject = BehaviorSubject<Superhero>();
  StreamSubscription? getFromFavoritesSubscription;
  StreamSubscription? requestSubscription;
  StreamSubscription? addToFavoriteSubscription;
  StreamSubscription? removeFromFavoriteSubscription;

  SuperheroBloc({this.client, required this.id}) {
    getFromFavorites();
  }

  void getFromFavorites() {
    getFromFavoritesSubscription?.cancel();
    getFromFavoritesSubscription = FavoriteSuperheroesStorage.getInstance().getSuperhero(id).asStream().listen(
      (superhero) {
        if (superhero != null) {
          superheroSubject.add(superhero);
          superheroPageStateSubject.add(SuperheroPageState.loaded);
        } else {
          superheroPageStateSubject.add(SuperheroPageState.loading);
        }
        requestSuperhero(superhero != null);
      },
      onError: (error, stackTrace) {
        print("Error happened in addToFavorite: $error, $stackTrace");
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
    addToFavoriteSubscription = FavoriteSuperheroesStorage.getInstance().addToFavorites(superhero).asStream().listen(
      (event) {
        print("Added to favorites: $event");
        superheroPageStateSubject.add(SuperheroPageState.loaded);
      },
      onError: (error, stackTrace) => print("Error happened in addToFavorite: $error, $stackTrace"),
    );
  }

  void removeFromFavorites() {
    removeFromFavoriteSubscription?.cancel();
    removeFromFavoriteSubscription = FavoriteSuperheroesStorage.getInstance().removeFromFavorites(id).asStream().listen(
      (event) {
        print("Removed from favorites: $event");
      },
      onError: (error, stackTrace) => print("Error happened in addToFavorite: $error, $stackTrace"),
    );
  }

  Stream<bool> observeIsFavorite() => FavoriteSuperheroesStorage.getInstance().observeIsFavorite(id);

  void requestSuperhero(final bool isInFavorite) {
    requestSubscription?.cancel();
    requestSubscription = request().asStream().listen(
      (superhero) {
        superheroSubject.add(superhero);
        superheroPageStateSubject.add(SuperheroPageState.loaded);
      },
      onError: (error, stackTrace) {
        if (!isInFavorite) {
          superheroPageStateSubject.add(SuperheroPageState.error);
        }
        print("Error happened in requestSuperhero: $error, $stackTrace");
      },
    );
  }

  void retry() {
    superheroPageStateSubject.add(SuperheroPageState.loading);
    requestSuperhero(false);
  }

  Future<Superhero> request() async {
    final token = dotenv.env["SUPERHERO_TOKEN"];
    await Future.delayed(const Duration(milliseconds: 500));
    final response = await (client ??= http.Client()).get(Uri.parse("https://superheroapi.com/api/$token/$id"));
    if (response.statusCode >= 500 && response.statusCode <= 599) {
      throw ApiException("Server error happened");
    }
    if (response.statusCode >= 400 && response.statusCode <= 499) {
      throw ApiException("Client error happened");
    }
    final decoded = json.decode(response.body);
    if (decoded['response'] == 'success') {
      final superhero = Superhero.fromJson(decoded as Map<String, dynamic>);
      await FavoriteSuperheroesStorage.getInstance().updateIfInFavorites(superhero);
      return superhero;
    } else if (decoded['response'] == 'error') {
      throw ApiException("Client error happened");
    }
    throw Exception("Unknown error happened");
  }

  Stream<Superhero> observeSuperhero() => superheroSubject.distinct();

  Stream<SuperheroPageState> observeSuperheroPageState() => superheroPageStateSubject.distinct();

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
