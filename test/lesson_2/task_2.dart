import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/widgets/superhero_card.dart';

import '../shared/internal/image_checks.dart';

///
/// 2. Упростить SuperheroCard (1 балл)
///
/// - Зарефакторить SuperheroCard. На вход нужно передавать не список с данными
///   (name, realName, и imageUrl), а superheroInfo с типом SuperheroInfo.
///   onTap оставить.
///
void runTestLesson2Task2() {
  testWidgets('module2', (WidgetTester tester) async {
    await mockNetworkImagesFor(() async {
      final batmanSuperheroInfo = SuperheroInfo(
        name: "Batman",
        realName: "Bruce Wayne",
        imageUrl: "https://www.superherodb.com/pictures2/portraits/10/100/639.jpg",
      );
      await testOneSuperhero(tester, batmanSuperheroInfo);

      final ironmanSuperheroInfo = SuperheroInfo(
        name: "Ironman",
        realName: "Tony Stark",
        imageUrl: "https://www.superherodb.com/pictures2/portraits/10/100/85.jpg",
      );
      await testOneSuperhero(tester, ironmanSuperheroInfo);
    });
  });
}

Future<void> testOneSuperhero(final WidgetTester tester, final SuperheroInfo superheroInfo ) async {
  await tester.pumpWidget(MaterialApp(
    home: SuperheroCard(
      superheroInfo: superheroInfo,
      onTap: () {},
    ),
  ));
  expect(
    find.text(superheroInfo.name.toUpperCase()),
    findsOneWidget,
    reason: """
Cannot find Text widget with text '${superheroInfo.name.toUpperCase()}' in SuperheroCard.
Tested on superheroInfo: $superheroInfo
        """,
  );
  expect(
    find.text(superheroInfo.realName),
    findsOneWidget,
    reason: """
Cannot find Text widget with text '${superheroInfo.realName}' in SuperheroCard.
Tested on superheroInfo: $superheroInfo
        """,
  );

  final imageFinder = find.byType(Image);
  expect(
    imageFinder,
    findsOneWidget,
    reason: "Cannot find Image in SuperheroCard",
  );
  final Image image = tester.widget(imageFinder);
  checkImageProperties(
    image: image,
    imageProvider: NetworkImage(superheroInfo.imageUrl),
  );
}
