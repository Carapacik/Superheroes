import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/pages/main_page.dart' as main;

import 'model/mocked_models.dart';
import 'task_1.mocks.dart';

///
/// 1. Ограничить возможность Dismissible, чтобы работал только на favorites
///    1. Сейчас возможно смахивать SuperheroCard на главном экране не только в
///       состоянии MainPageState.favorites, но еще и на
///       MainPageState.searchResults. Оставить такую возможность только в
///       состоянии MainPageState.favorites.
///    2. Добавить в виджет ListTile на странице MainPage новый обязательный
///       параметр ableToSwipe типа bool.
///    3. Если ableToSwipe = true, то мы должны оборачивать SuperheroCard в
///       Dismissible со всей соответствующей логикой, которая есть сейчас.
///    4. Если ableToSwipe = false, то  Dismissible не добавлять, а сразу
///       возвращать SuperheroCard. Свайп в этом случае работать не должен
///
@GenerateMocks([http.Client])
void runTestLesson4Task1() {
  setUp(() {
    final values = <String, dynamic>{};
    const MethodChannel('plugins.flutter.io/shared_preferences')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getAll') {
        return values; // set initial values here if desired
      } else if (methodCall.method.startsWith("set")) {
        values[methodCall.arguments["key"]] = methodCall.arguments["value"];
        return true;
      } else if (methodCall.method == "getInt") {
        return values[methodCall.arguments["key"]];
      }
      return null;
    });
  });

  testWidgets('module1', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await mockNetworkImagesFor(() async {
        final client = MockClient();
        final prefs = await SharedPreferences.getInstance();
        await prefs.setStringList("favorite_superheroes", []);

        final bloc = MainBloc(client: client);

        await tester.pumpWidget(
          Material(
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Provider.value(
                value: bloc,
                child: main.ListTile(
                  ableToSwipe: false,
                  superhero: SuperheroInfo.fromSuperhero(superhero1),
                ),
              ),
            ),
          ),
        );

        expect(
          find.byType(Dismissible),
          findsNothing,
          reason:
              "If you pass ableToSwipe: false into ListTile, you should not use Dismissible widget",
        );

        await tester.pumpWidget(
          Material(
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Provider.value(
                value: bloc,
                child: main.ListTile(
                  ableToSwipe: true,
                  superhero: SuperheroInfo.fromSuperhero(superhero1),
                ),
              ),
            ),
          ),
        );

        expect(
          find.byType(Dismissible),
          findsOneWidget,
          reason: "If you pass ableToSwipe: true into ListTile, you should use Dismissible widget",
        );
      });
    });
  });
}
