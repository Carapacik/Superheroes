import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:superheroes/pages/superhero_page.dart';

import 'model/mocked_models.dart';
import 'task_3.mocks.dart';

///
/// 3. Дополнить CachedNetworkImage в SuperheroPage. Если сейчас картинка
///    отсутствует, показывается виджет-заглушка, определенный в
///    CachedNetworkImage. Надо переопределить 2 параметра в этом виджете —
///    placeholder и errorWidget.
///    1. В качестве placeholder'а показывать виджет с заливкой сплошным цветом
///       (см. макеты)
///    2. В качестве errorWidget'а показывать виджет с картинкой с человечком с
///       вопросительным знаком на подложке с заливкой сплошного цвета (см
///       макеты).
///    3. Добавлять виджеты ТОЛЬКО в placeholder и errorWidget
///
@GenerateMocks([http.Client])
void runTestLesson4Task3() {
  testGoldens('module3', (WidgetTester tester) async {
    final client = MockClient();

    SharedPreferences.setMockInitialValues({"favorite_superheroes": []});

    final uriCreator = (superheroId) =>
        Uri.parse("https://superheroapi.com/api/${dotenv.env["SUPERHERO_TOKEN"]}/$superheroId");
    when(client.get(uriCreator(superhero1.id))).thenAnswer(
      (_) async => http.Response(
        json.encode(superheroResponse1.toJson()),
        200,
      ),
    );
    await tester.pumpWidget(
      MaterialApp(home: SuperheroPage(id: superhero1.id, client: client)),
    );

    await tester.pumpAndSettle();
    final cachedNetworkImageFinder = find.byType(CachedNetworkImage);

    expect(
      cachedNetworkImageFinder,
      findsOneWidget,
      reason: "There should be a CachedNetworkImage widget in SuperheroAppBar",
    );
    final CachedNetworkImage cachedNetworkImage = tester.widget(cachedNetworkImageFinder);
    expect(
      cachedNetworkImage.placeholder,
      isNotNull,
      reason: "placeholder property in CachedNetworkImage shouldn't be null",
    );
    expect(
      cachedNetworkImage.errorWidget,
      isNotNull,
      reason: "errorWidget property in CachedNetworkImage shouldn't be null",
    );

    final widgetCreator = (Widget widgetCreator(BuildContext context)) => Material(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Builder(builder: (context) {
              return SizedBox(
                height: 328,
                width: 360,
                child: widgetCreator(context),
              );
            }),
          ),
        );

    await tester.pumpWidgetBuilder(
      Center(
          child: (GoldenBuilder.column()
                ..addScenario(
                  'placeholder',
                  widgetCreator(
                    (context) => cachedNetworkImage.placeholder!(context, superhero1.image.url),
                  ),
                )
                ..addScenario(
                  'errorWidget',
                  widgetCreator(
                    (context) =>
                        cachedNetworkImage.errorWidget!(context, superhero1.image.url, null),
                  ),
                ))
              .build()),
      surfaceSize: const Size(328, 800),
    );
    await screenMatchesGolden(
      tester,
      'superheroes_lesson_4_task_3_${Platform.operatingSystem}',
      autoHeight: true,
    );
  });
}
