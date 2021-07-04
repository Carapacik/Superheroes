import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/main.dart';
import 'package:superheroes/pages/main_page.dart';
import 'package:superheroes/widgets/action_button.dart';

import '../shared/test_helpers.dart';
import 'shared.dart';

void runTestLesson1Task5() {
  testWidgets('module5', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();

    await reachNeededState(tester, MainPageState.favorites);

    final columnFinder = find.descendant(
      of: find.byType(MainPageStateWidget),
      matching: find.descendant(of: find.byType(Stack), matching: find.byType(Column)),
    );

    expect(
      columnFinder,
      findsOneWidget,
      reason: "There should be a Column inside MainPageWidget in MainPageContent",
    );

    final Column column = tester.widget(columnFinder);

    // if (column.mainAxisAlignment != MainAxisAlignment.center) {
    //   final centerFinder = findTypeByChildTypeOnlyInParentType(Center, Column, Stack);
    //   final Iterable<Center> centerWidgets = tester.widgetList(centerFinder);
    //   if (centerWidgets.length == 0) {
    //     final alignFinder = findTypeByChildTypeOnlyInParentType(Align, Column, Stack);
    //     expect(
    //       alignFinder,
    //       findsOneWidget,
    //       reason: "\nColumn either should have mainAxisAlignment = MainAxisAlignment.center \n"
    //           "or need to have mainAxisSize = MainAxisSize.min and be wrapped with Center or \n"
    //           "Align(alignment: Alignment.center) widgets",
    //     );
    //     final Align align = tester.widget(alignFinder);
    //     expect(
    //       align.alignment,
    //       Alignment.center,
    //       reason: "\nColumn either should have mainAxisAlignment = MainAxisAlignment.center \n"
    //           "or need to have mainAxisSize = MainAxisSize.min and be wrapped with Center or \n"
    //           "Align(alignment: Alignment.center) widgets",
    //     );
    //   }
    // }
    //
    // final stackInColumnFinder = find.descendant(of: columnFinder, matching: find.byType(Stack));
    //
    // expect(
    //   stackInColumnFinder,
    //   findsOneWidget,
    //   reason: "There should be a Stack inside Column",
    // );
    //
    // final Stack stackInColumn = tester.firstWidget(stackInColumnFinder);
    //
    // expect(
    //   stackInColumn.children.length,
    //   2,
    //   reason: "There should be 2 widgets inside Stack: one with circle and other with image",
    // );
    //
    // final Widget firstWidgetInStack = stackInColumn.children[0];
    //
    // expect(
    //   firstWidgetInStack,
    //   isInstanceOf<Container>(),
    //   reason: "First widget inside Stack should be a Container",
    // );
    //
    // final Container container = firstWidgetInStack as Container;
    //
    // checkContainerDecorationShape(container: container, shape: BoxShape.circle);
    // checkContainerDecorationColor(container: container, color: const Color(0xFF00BCD4));
    // checkContainerWidthOrHeightProperties(
    //   container: container,
    //   widthAndHeight: WidthAndHeight(width: 108, height: 108),
    // );
    //
    // final Widget secondWidgetInStack = stackInColumn.children[1];
    //
    // expect(
    //   secondWidgetInStack,
    //   isInstanceOf<Padding>(),
    //   reason: "Second widget inside Stack should be a Padding",
    // );
    //
    // final Padding padding = secondWidgetInStack as Padding;
    //
    // checkEdgeInsetParam(
    //   widgetName: "Padding",
    //   param: padding.padding,
    //   paramName: "",
    //   edgeInsetsCheck: EdgeInsetsCheck(top: 9),
    // );
    //
    // expect(
    //   padding.child,
    //   isInstanceOf<Image>(),
    //   reason: "Child of Padding should be an Image",
    // );
    //
    // final Image image = padding.child as Image;
    // checkImageProperties(
    //   image: image,
    //   width: 108,
    //   height: 119,
    //   imageProvider: AssetImage("assets/images/ironman.png"),
    // );
    //
    // final noFavoritesYetTextFinder = find.text("No favorites yet");
    //
    // expect(
    //   noFavoritesYetTextFinder,
    //   findsOneWidget,
    //   reason: "There should be a Text with text 'No favorites yet'",
    // );
    //
    // final Text noFavoritesYetText = tester.firstWidget(noFavoritesYetTextFinder);
    //
    // checkTextProperties(
    //   textWidget: noFavoritesYetText,
    //   textColor: const Color(0xFFFFFFFF),
    //   fontSize: 32,
    //   fontWeight: FontWeight.w800,
    // );
    //
    // final searchAndAddTextFinder = find.text("Search and add".toUpperCase());
    //
    // expect(
    //   searchAndAddTextFinder,
    //   findsOneWidget,
    //   reason: "There should be a Text with text 'SEARCH AND ADD'",
    // );
    //
    // final Text searchAndAddText = tester.firstWidget(searchAndAddTextFinder);
    //
    // checkTextProperties(
    //   textWidget: searchAndAddText,
    //   textColor: const Color(0xFFFFFFFF),
    //   fontSize: 16,
    //   fontWeight: FontWeight.w700,
    // );
    //
    // final actionButtonWithSearchFinder =
    //     findTypeByTextOnlyInParentType(ActionButton, "SEARCH", Column);
    //
    // expect(
    //   actionButtonWithSearchFinder,
    //   findsOneWidget,
    //   reason: "There should be an ActionButton with text 'SEARCH'",
    // );
    //
    expect(
      column.children.length,
      6,
      reason:
          "There should be 7 widgets inside Column. 1 widget with circle and image, 2 widget with texts, 1 ActionButton and 3 empty SizedBoxes as paddings",
    );

    expect(
      column.children[1],
      isInstanceOf<SizedBox>(),
      reason: "Second widget in Column should be a SizedBox",
    );

    expect(
      (column.children[1] as SizedBox).height,
      20,
      reason: "SizedBox between widget with blue circle with iron man and title should be 20",
    );

    expect(
      column.children[3],
      isInstanceOf<SizedBox>(),
      reason: "Fourth widget in Column should be a SizedBox",
    );

    expect(
      (column.children[3] as SizedBox).height,
      20,
      reason: "SizedBox between title widget and subtitle should be 20",
    );

    expect(
      column.children[5],
      isInstanceOf<SizedBox>(),
      reason: "Sixth widget in Column should be a SizedBox",
    );

    expect(
      (column.children[5] as SizedBox).height,
      30,
      reason: "SizedBox between subtitle widget and ActionButton should be 30",
    );
  });
}
