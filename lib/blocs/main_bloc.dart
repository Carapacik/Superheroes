import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:superheroes/exception/api_exception.dart';
import 'package:superheroes/model/alignment_info.dart';
import 'package:superheroes/model/superhero.dart';
import 'package:superheroes/utils/constants.dart';
import 'package:superheroes/utils/favorite_superheroes_storage.dart';

// ignore_for_file: avoid_annotating_with_dynamic, avoid_types_on_closure_parameters
class MainBloc {
  MainBloc({this.client}) {
    textSubscription =
        Rx.combineLatest2<String, List<Superhero>, MainPageStateInfo>(
      currentTextSubject
          .distinct()
          .debounceTime(const Duration(milliseconds: 300)),
      FavoriteSuperheroesStorage.getInstance().observeFavoriteSuperheroes(),
      (searchText, haveFavorites) => MainPageStateInfo(
        searchText,
        haveFavorites: haveFavorites.isNotEmpty,
      ),
    ).listen((value) {
      searchSubscription?.cancel();
      if (value.searchText.isEmpty) {
        if (value.haveFavorites) {
          stateSubject.add(MainPageState.favorites);
        } else {
          stateSubject.add(MainPageState.noFavorites);
        }
      } else if (value.searchText.length < minSymbols) {
        stateSubject.add(MainPageState.minSymbols);
      } else {
        searchForSuperheroes(value.searchText);
      }
    });
  }

  http.Client? client;
  static const minSymbols = 3;

  final BehaviorSubject<MainPageState> stateSubject = BehaviorSubject();

  final BehaviorSubject<List<SuperheroInfo>> searchedSuperheroSubject =
      BehaviorSubject<List<SuperheroInfo>>();

  final currentTextSubject = BehaviorSubject<String>.seeded('');

  StreamSubscription? textSubscription;
  StreamSubscription? searchSubscription;
  StreamSubscription? removeFromFavoriteSubscription;

  Stream<List<SuperheroInfo>> observeSearchedSuperheroes() =>
      searchedSuperheroSubject;

  Stream<MainPageState> observeMainPageState() => stateSubject;

  void searchForSuperheroes(final String text) {
    stateSubject.add(MainPageState.loading);
    searchSubscription = search(text).asStream().listen(
      (searchResults) {
        if (searchResults.isEmpty) {
          stateSubject.add(MainPageState.nothingFound);
        } else {
          searchedSuperheroSubject.add(searchResults);
          stateSubject.add(MainPageState.searchResults);
        }
      },
      onError: (Object error) {
        stateSubject.add(MainPageState.loadingError);
      },
    );
  }

  void removeFromFavorites(final int id) {
    removeFromFavoriteSubscription?.cancel();
    removeFromFavoriteSubscription = FavoriteSuperheroesStorage.getInstance()
        .removeFromFavorites(id)
        .asStream()
        .listen((event) {});
  }

  void retry() {
    final currentText = currentTextSubject.value;
    searchForSuperheroes(currentText);
  }

  Future<List<SuperheroInfo>> search(final String text) async {
    final response = await (client ??= http.Client()).get(
      Uri.parse('$baseUrl/all.json'),
    );
    if (response.statusCode >= 500 && response.statusCode <= 599) {
      throw const ApiException('Server error happened');
    }
    if (response.statusCode >= 400 && response.statusCode <= 499) {
      throw const ApiException('Client error happened');
    }
    final results = json.decode(response.body) as List;
    final superheroes = results
        .map(
          (dynamic rawHero) =>
              Superhero.fromJson(rawHero as Map<String, dynamic>),
        )
        .where(
          (element) => element.name.toLowerCase().contains(text.toLowerCase()),
        );
    final found = superheroes.map(SuperheroInfo.fromSuperhero).toList();
    return found;
  }

  void nextState() {
    final currentState = stateSubject.value;
    final nextState = MainPageState.values[
        (MainPageState.values.indexOf(currentState) + 1) %
            MainPageState.values.length];
    stateSubject.add(nextState);
  }

  void updateText(final String? text) {
    currentTextSubject.add(text ?? '');
  }

  Stream<List<SuperheroInfo>> observeFavoriteSuperheroes() =>
      FavoriteSuperheroesStorage.getInstance().observeFavoriteSuperheroes().map(
            (superheroes) =>
                superheroes.map(SuperheroInfo.fromSuperhero).toList(),
          );

  void dispose() {
    stateSubject.close();
    searchedSuperheroSubject.close();
    currentTextSubject.close();

    textSubscription?.cancel();
    searchSubscription?.cancel();
    removeFromFavoriteSubscription?.cancel();

    client?.close();
  }
}

enum MainPageState {
  noFavorites,
  minSymbols,
  loading,
  nothingFound,
  loadingError,
  searchResults,
  favorites,
}

@immutable
class SuperheroInfo {
  const SuperheroInfo({
    required this.id,
    required this.name,
    required this.realName,
    required this.imageUrl,
    this.alignmentInfo,
  });

  factory SuperheroInfo.fromSuperhero(final Superhero superhero) =>
      SuperheroInfo(
        id: superhero.id,
        name: superhero.name,
        realName: superhero.biography.fullName,
        imageUrl: superhero.images.lg,
        alignmentInfo: superhero.biography.alignmentInfo,
      );

  final int id;
  final String name;
  final String realName;
  final String imageUrl;
  final AlignmentInfo? alignmentInfo;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SuperheroInfo &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          realName == other.realName &&
          imageUrl == other.imageUrl;

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ realName.hashCode ^ imageUrl.hashCode;
}

@immutable
class MainPageStateInfo {
  const MainPageStateInfo(this.searchText, {required this.haveFavorites});

  final String searchText;
  final bool haveFavorites;

  @override
  String toString() =>
      'MainPageStateInfo{searchText: $searchText, haveFavorites: $haveFavorites}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MainPageStateInfo &&
          runtimeType == other.runtimeType &&
          searchText == other.searchText &&
          haveFavorites == other.haveFavorites;

  @override
  int get hashCode => searchText.hashCode ^ haveFavorites.hashCode;
}
