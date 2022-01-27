import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:superheroes/pages/superhero_page.dart';

import '../shared/test_helpers.dart';
import 'model/mocked_models.dart';

///
/// 4. Сверстать BiographyWidget.
///    1. Этот виджет должен иметь отступы от боков экрана, равные 16
///       логическим пикселям у себя внутри.
///    2. Все размеры, цвета и стили должны совпадать с макетом
///
void runTestLesson4Task4() {
  setUp(() {
    PathProviderPlatform.instance = FakePathProviderPlatform();
  });
  testGoldens('module4', (WidgetTester tester) async {
    await tester.pumpWidgetBuilder(
      Center(
          child: (GoldenBuilder.column()
                ..addScenario('good', BiographyWidget(biography: bio1))
                ..addScenario('neutral', BiographyWidget(biography: bio2))
                ..addScenario('bad', BiographyWidget(biography: bio3)))
              .build()),
      surfaceSize: const Size(328, 900),
    );
    await screenMatchesGolden(
        tester, 'superheroes_lesson_4_task_4_${Platform.operatingSystem}',
        autoHeight: true);
  });
}
