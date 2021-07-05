import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/main.dart';
import 'package:superheroes/pages/main_page.dart';
import 'package:superheroes/widgets/superhero_card.dart';

import '../shared/test_helpers.dart';
import 'shared.dart';

void runTestLesson1Task5() {
  testWidgets('module5', (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();

      await reachNeededState(tester, MainPageState.favorites);

      final yourFavoritesTextFinder = find.text("Your favorites");

      expect(
        yourFavoritesTextFinder,
        findsOneWidget,
        reason: "There should be a Text with text 'Your favorites'",
      );

      final Text yourFavoritesText = tester.firstWidget(yourFavoritesTextFinder);

      checkTextProperties(
        textWidget: yourFavoritesText,
        textColor: const Color(0xFFFFFFFF),
        fontSize: 24,
        fontWeight: FontWeight.w800,
      );

      final columnFinder =
          findTypeByTextOnlyInParentType(Column, "Your favorites", MainPageStateWidget);

      expect(
        columnFinder,
        findsOneWidget,
        reason: "There should be a Column inside MainPageStateWidget ",
      );

      final Column column = tester.widget(columnFinder);

      final paddingOfText = find.descendant(
        of: columnFinder,
        matching: find.ancestor(
          of: yourFavoritesTextFinder,
          matching: find.byType(Padding),
        ),
      );

      expect(
        paddingOfText,
        findsOneWidget,
        reason: "Text with text 'Your favorites' should be wrapped with Padding",
      );

      final Padding yourFavoritesPadding = tester.widget(paddingOfText);

      checkEdgeInsetParam(
        widgetName: "Padding",
        param: yourFavoritesPadding.padding,
        paramName: "",
        edgeInsetsCheck: EdgeInsetsCheck(left: 16, right: 16),
      );

      final batmanCardFinder =
          findTypeByTextOnlyInParentType(SuperheroCard, "BATMAN", MainPageStateWidget);

      expect(
        batmanCardFinder,
        findsOneWidget,
        reason: "There should be a SuperheroCard with Batman",
      );

      final SuperheroCard batmanCard = tester.widget(batmanCardFinder);
      expect(
        batmanCard.name,
        "Batman",
        reason: "SuperheroCard with Batman should have 'Batman' as a name parameter",
      );
      expect(
        batmanCard.realName,
        "Bruce Wayne",
        reason: "SuperheroCard with Batman should have 'Bruce Wayne' as a realName parameter",
      );
      final batmanUrl = "https://www.superherodb.com/pictures2/portraits/10/100/639.jpg";
      expect(
        batmanCard.imageUrl,
        batmanUrl,
        reason: "SuperheroCard with Batman should have '$batmanUrl' as an imageUrl parameter",
      );

      final paddingOfBatmanCardTextFinder = find.descendant(
        of: columnFinder,
        matching: find.ancestor(
          of: batmanCardFinder,
          matching: find.byType(Padding),
        ),
      );

      expect(
        paddingOfBatmanCardTextFinder,
        findsOneWidget,
        reason: "SuperheroCard with Batman should be wrapped with Padding",
      );

      final Padding paddingOfBatmanCardText = tester.widget(paddingOfBatmanCardTextFinder);
      checkEdgeInsetParam(
        widgetName: "Padding",
        param: paddingOfBatmanCardText.padding,
        paramName: "",
        edgeInsetsCheck: EdgeInsetsCheck(left: 16, right: 16),
      );
      // --------------?

      final ironmanCardFinder =
          findTypeByTextOnlyInParentType(SuperheroCard, "IRONMAN", MainPageStateWidget);

      expect(
        ironmanCardFinder,
        findsOneWidget,
        reason: "There should be a SuperheroCard with Ironman",
      );

      final SuperheroCard ironmanCard = tester.widget(ironmanCardFinder);
      expect(
        ironmanCard.name,
        "Ironman",
        reason: "SuperheroCard with Batman should have 'Ironman' as a name parameter",
      );
      expect(
        ironmanCard.realName,
        "Tony Stark",
        reason: "SuperheroCard with Batman should have 'Tony Stark' as a realName parameter",
      );
      final ironmanUrl = "https://www.superherodb.com/pictures2/portraits/10/100/85.jpg";
      expect(
        ironmanCard.imageUrl,
        ironmanUrl,
        reason: "SuperheroCard with Batman should have '$ironmanUrl' as an imageUrl parameter",
      );

      final paddingOfIronmanCardTextFinder = find.descendant(
        of: columnFinder,
        matching: find.ancestor(
          of: ironmanCardFinder,
          matching: find.byType(Padding),
        ),
      );

      expect(
        paddingOfIronmanCardTextFinder,
        findsOneWidget,
        reason: "SuperheroCard with Ironman should be wrapped with Padding",
      );

      final Padding paddingOfIronmanCardText = tester.widget(paddingOfIronmanCardTextFinder);
      checkEdgeInsetParam(
        widgetName: "Padding",
        param: paddingOfIronmanCardText.padding,
        paramName: "",
        edgeInsetsCheck: EdgeInsetsCheck(left: 16, right: 16),
      );

      final containerInsideSuperheroCard = find.descendant(
        of: batmanCardFinder,
        matching: find.ancestor(
          of: find.byType(Row),
          matching: find.byType(Container),
        ),
      );

      expect(
        containerInsideSuperheroCard,
        findsOneWidget,
        reason: "SuperheroCard should have a Container above the Row",
      );

      final Container topLevelSuperheroCardContainer = tester.widget(containerInsideSuperheroCard);
      checkContainerColor(
        container: topLevelSuperheroCardContainer,
        color: const Color(0xFF2C3243),
      );
      checkContainerWidthOrHeightProperties(
        container: topLevelSuperheroCardContainer,
        widthAndHeight: WidthAndHeight(height: 70),
      );

      final superheroCardRowFinder = find.descendant(
        of: batmanCardFinder,
        matching: find.byType(Row),
      );

      expect(
        superheroCardRowFinder,
        findsOneWidget,
        reason: "SuperheroCard should have a Row inside Container",
      );

      final Row superheroCardRow = tester.widget(superheroCardRowFinder);
      expect(
        superheroCardRow.children.length,
        3,
        reason: "Row inside SuperheroCard should have 3 children widgets",
      );

      expect(
        superheroCardRow.children[0],
        isInstanceOf<Image>(),
        reason: "First child in Row inside SuperheroCard should be an Image",
      );

      final Image imageInSuperHeroCard = superheroCardRow.children[0] as Image;
      checkImageProperties(
        image: imageInSuperHeroCard,
        height: 70,
        width: 70,
        boxFit: BoxFit.cover,
      );

      expect(
        superheroCardRow.children[1],
        isInstanceOf<SizedBox>(),
        reason: "Second child in Row inside SuperheroCard should be a SizedBox",
      );
      final SizedBox sizedBoxInsideSuperheroCard = superheroCardRow.children[1] as SizedBox;
      expect(
        sizedBoxInsideSuperheroCard.width,
        12,
        reason: "SizedBox inside Row in SuperheroCard should have 12 width",
      );

      expect(
        superheroCardRow.children[2],
        isInstanceOf<Expanded>(),
        reason: "Third child in Row inside SuperheroCard should be a Expanded",
      );

      expect(
        (superheroCardRow.children[2] as Expanded).child,
        isInstanceOf<Column>(),
        reason: "Third child in Row inside SuperheroCard should be a Expanded with Column as a child",
      );

      final Column columnInsideSuperheroCard = (superheroCardRow.children[2] as Expanded).child as Column;
      expect(
        columnInsideSuperheroCard.children.length,
        2,
        reason: "Column inside SuperheroCard should have 2 children widgets",
      );

      expect(
        columnInsideSuperheroCard.crossAxisAlignment,
        CrossAxisAlignment.start,
        reason:
            "Column inside SuperheroCard should have crossAxisAlignment = CrossAxisAlignment.start",
      );
      expect(
        columnInsideSuperheroCard.mainAxisAlignment,
        MainAxisAlignment.center,
        reason:
            "Column inside SuperheroCard should have mainAxisAlignment = MainAxisAlignment.center",
      );

      expect(
        columnInsideSuperheroCard.children[0],
        isInstanceOf<Text>(),
        reason: "Column inside SuperheroCard should have two Text widgets",
      );

      expect(
        columnInsideSuperheroCard.children[1],
        isInstanceOf<Text>(),
        reason: "Column inside SuperheroCard should have two Text widgets",
      );

      expect(
        column.children.length,
        6,
        reason: "There should be 6 widgets inside Column. Widget with text 'Your favorites',"
            " SuperheroCard with Batman, SuperheroCard with Ironman and 3 SizedBoxes",
      );

      expect(
        column.children[0],
        isInstanceOf<SizedBox>(),
        reason: "First widget in Column should be a SizedBox",
      );

      expect(
        (column.children[0] as SizedBox).height,
        90,
        reason: "Top SizedBox should have 90 height",
      );

      expect(
        column.children[2],
        isInstanceOf<SizedBox>(),
        reason: "Third widget in Column should be a SizedBox",
      );

      expect(
        (column.children[2] as SizedBox).height,
        20,
        reason: "Top SizedBox between title and first SuperheroCard should have 20 height",
      );

      expect(
        column.children[4],
        isInstanceOf<SizedBox>(),
        reason: "Fifth widget in Column should be a SizedBox",
      );

      expect(
        (column.children[4] as SizedBox).height,
        8,
        reason: "SizedBox between two SuperheroCards should have 8 height",
      );
    });
  });
}
