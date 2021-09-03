import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:superheroes/blocs/superhero_bloc.dart';

import '../shared/test_helpers.dart';
import 'model/mocked_models.dart';
import 'task_7.mocks.dart';

///
/// 7. Добавить метод observeSuperheroPageState() в SuperheroBloc.
///    1. Создать enum SuperheroPageState с тремя значениями: loading, loaded,
///       error
///    2. В SuperheroBloc добавить метод observeSuperheroPageState(), в котором
///       возвращать текущее состояние.
///    3. Начального состояния быть не должно.
///    4. После того как заходим на страницу супергероя смотрим, сохранен ли
///       этот супергерой в избранном или нет:
///        1. Если не сохранен, выдаем состояние SuperheroPageState.loading
///        2. Если сохранен, выдаем состояние SuperheroPageState.loaded
///    5. Если загрузка из сети закончилась с ошибкой и текущий супергерой
///       доступен нам из избранного (то есть раньше уже выдали состояние
///       SuperheroPageState.loaded), не выдаем никакого дополнительного
///       состояния.
///    6. Если загрузка из сети закончилась с ошибкой, но текущий супергерой не
///       доступен нам из избранного, выдаем состояние SuperheroPageState.error.
///    7. Если загрузка из сети закончилась без ошибки, выдаем состояние на
///       SuperheroPageState.loaded
///    8. Фильтровать повторяющиеся значения. То есть не выдавать в методе
///       observeSuperheroPageState() SuperheroPageState.loaded (или
///       SuperheroPageState.error) два раза подряд
///
@GenerateMocks([http.Client])
void runTestLesson4Task7() {
  // setUp(() {
  //   final values = <String, dynamic>{};
  //   const MethodChannel('plugins.flutter.io/shared_preferences')
  //       .setMockMethodCallHandler((MethodCall methodCall) async {
  //     if (methodCall.method == 'getAll') {
  //       return values; // set initial values here if desired
  //     } else if (methodCall.method.startsWith("set")) {
  //       values[methodCall.arguments["key"]] = methodCall.arguments["value"];
  //       return true;
  //     } else if (methodCall.method == "getInt") {
  //       return values[methodCall.arguments["key"]];
  //     }
  //     return null;
  //   });
  // });

  testWidgets('module7', (WidgetTester tester) async {
    await mockNetworkImagesFor(() async {
      await tester.runAsync(() async {
        final client = MockClient();
        final uriCreator = (superheroId) =>
            Uri.parse("https://superheroapi.com/api/${dotenv.env["SUPERHERO_TOKEN"]}/$superheroId");

        SharedPreferences.setMockInitialValues({"favorite_superheroes": []});

        // CASE 1:
        // 1. no info about superhero in favorites
        // 2. server returns successful response

        when(client.get(uriCreator(superhero1.id))).thenAnswer(
          (_) async => http.Response(
            json.encode(superheroResponse1.toJson()),
            200,
          ),
        );
        final bloc1 = SuperheroBloc(client: client, id: superhero1.id);
        await expectEmitsInOrderWithTimeoutAndThenDone(
          bloc1.observeSuperheroPageState(),
          [SuperheroPageState.loading, SuperheroPageState.loaded],
          reason: "ASAAAAAAAAAA",
        );

        // CASE 2:
        // 1. superhero saved in favorites
        // 2. server returns successful response

        when(client.get(uriCreator(superhero2.id))).thenAnswer(
          (_) async => http.Response(
            json.encode(superheroResponse2.toJson()),
            200,
          ),
        );

        SharedPreferences.setMockInitialValues({
          "favorite_superheroes": [json.encode(superhero2.toJson())],
        });

        final bloc2 = SuperheroBloc(client: client, id: superhero2.id);

        await expectEmitsInOrderWithTimeoutAndThenDone(
          bloc2.observeSuperheroPageState(),
          [SuperheroPageState.loaded],
          reason: "ASAAAAAAAAAA333",
        );

        // CASE 3:
        // 1. superhero saved in favorites
        // 2. server returns error response

        when(client.get(uriCreator(superhero3.id))).thenAnswer(
          (_) async => http.Response(
            json.encode(superheroResponseWithError.toJson()),
            200,
          ),
        );

        SharedPreferences.setMockInitialValues({
          "favorite_superheroes": [json.encode(superhero3.toJson())],
        });

        final bloc3 = SuperheroBloc(client: client, id: superhero3.id);

        await expectEmitsInOrderWithTimeoutAndThenDone(
          bloc3.observeSuperheroPageState(),
          [SuperheroPageState.loaded],
          reason: "ASAAAAAAAAAA4444",
        );

        // CASE 4:
        // 1. no info about superhero in favorites
        // 2. server returns error response

        when(client.get(uriCreator(superhero3.id))).thenAnswer(
          (_) async => http.Response(
            json.encode(superheroResponseWithError.toJson()),
            200,
          ),
        );

        SharedPreferences.setMockInitialValues({"favorite_superheroes": []});

        final bloc4 = SuperheroBloc(client: client, id: superhero3.id);

        await expectEmitsInOrderWithTimeoutAndThenDone(
          bloc4.observeSuperheroPageState(),
          [SuperheroPageState.loading, SuperheroPageState.error],
          reason: "ASAAAAAAAAAA555",
        );
      });
    });
  });
}
