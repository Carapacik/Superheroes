import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/pages/main_page.dart' as main;

import 'model/mocked_models.dart';
import 'task_2.mocks.dart';

///
/// 2. Дополнить логику работы виджета Dismissible в виджете ListTile, что на
///    странице MainPage показывается.
///    1. При смахивании вправо показывать текст Remove from favorites в столбик
///       с равнением с левой стороны (см. макеты).
///    2. При смахивании влево, показывать текст Remove from favorites в стобик
///       с равненим с правой стороны (см. макеты).
///    3. Использовать только возможности виджета Dismissible, то есть изменения
///       вносить только в параметры этого виджета.
///    4. Текст разбить в 3 строки с помощью символов \n, не делить на несколько
///       виджетов
///
@GenerateMocks([http.Client])
void runTestLesson4Task2() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    MethodChannel('plugins.flutter.io/path_provider')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      return ".";
    });
  });
  testGoldens('module2', (WidgetTester tester) async {
    await mockNetworkImagesFor(() async {
      final client = MockClient();

      SharedPreferences.setMockInitialValues({"favorite_superheroes": []});

      final bloc = MainBloc(client: client);

      await tester.pumpWidget(
        Material(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Provider.value(
              value: bloc,
              child: main.ListTile(
                superhero: SuperheroInfo.fromSuperhero(superhero1),
                ableToSwipe: true,
              ),
            ),
          ),
        ),
      );

      final dismissibleFinder = find.byType(Dismissible);

      expect(
        dismissibleFinder,
        findsOneWidget,
        reason:
            "There should be a Dismissible widget on the main screen if favorite superheroes exist",
      );

      final Dismissible dismissible = tester.widget(dismissibleFinder);

      expect(
        dismissible.background,
        isNotNull,
        reason: "background property in Dismissible should not be null",
      );

      expect(
        dismissible.secondaryBackground,
        isNotNull,
        reason:
            "secondaryBackground property in Dismissible should not be null",
      );

      await tester.pumpWidgetBuilder(
        Center(
            child: (GoldenBuilder.column()
                  ..addScenario(
                    'swipe to the right',
                    Material(
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: dismissible.background!,
                      ),
                    ),
                  )
                  ..addScenario(
                    'swipe to the left',
                    Material(
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: dismissible.secondaryBackground!,
                      ),
                    ),
                  ))
                .build()),
        surfaceSize: const Size(328, 300),
      );
      await screenMatchesGolden(
        tester,
        'superheroes_lesson_4_task_2_${Platform.operatingSystem}',
        autoHeight: true,
      );
      bloc.dispose();
    });
  });
}
