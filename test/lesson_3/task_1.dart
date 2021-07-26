import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/widgets/superhero_card.dart';

import '../shared/internal/container_checks.dart';
import '../shared/internal/finders.dart';

///
/// 1. Добавить подложку под картинку
///     1. В виджете SuperheroCard обернуть CachedNetworkImage в Container
///     2. Цветом контейнера должен быть Colors.white24
///     3. Размеры контейнера 70x70
///
void runTestLesson3Task1() {
  testWidgets('module1', (WidgetTester tester) async {
    await tester.runAsync(() async {
      final batmanSuperheroInfo = SuperheroInfo(
        name: "Batman",
        realName: "Bruce Wayne",
        imageUrl:
            "https://www.superherodb.com/pictures2/portraits/10/100/639.jpg",
      );
      final card =
          SuperheroCard(superheroInfo: batmanSuperheroInfo, onTap: () {});
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Material(child: card),
        ),
      );

      final placeholderContainerFinder = findTypeByChildTypeOnlyInParentType(
          Container, CircularProgressIndicator, Row);

      expect(
        placeholderContainerFinder,
        findsOneWidget,
        reason:
            "There should be a Container widget that wraps CachedNetworkImage",
      );

      final Container container = tester.widget(placeholderContainerFinder);
      checkContainerWidthOrHeightProperties(
        container: container,
        widthAndHeight: WidthAndHeight(width: 70, height: 70),
      );
      checkContainerColor(container: container, color: Colors.white24);
    });
  });
}
