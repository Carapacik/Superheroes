import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:superheroes/main.dart';
import 'package:superheroes/widgets/action_button.dart';

import '../shared/test_helpers.dart';

void runTestLesson1Task2() {
  testWidgets('module2', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();

    final actionButtonFinder =
        findTypeByTextOnlyInParentType(ActionButton, "Next State".toUpperCase(), Stack);
    expect(
      actionButtonFinder,
      findsOneWidget,
      reason: "There should be an ActionButton with text 'NEXT STATE' in Stack",
    );

    final containerFinder =
        findTypeByTextOnlyInParentType(Container, "Next State".toUpperCase(), ActionButton);

    expect(
      containerFinder,
      findsOneWidget,
      reason: "There are should be a Container inside ActionButton",
    );

    final Container container = tester.firstWidget(containerFinder);

    checkContainerEdgeInsetsProperties(
      container: container,
      padding: EdgeInsetsCheck(left: 20, right: 20, top: 8, bottom: 8),
    );

    checkContainerDecorationBorderRadius(
      container: container,
      borderRadius: BorderRadius.circular(8),
    );

    checkContainerDecorationColor(
      container: container,
      color: const Color(0xFF00BCD4),
    );

    final gestureDetectorFinder =
        findTypeByTextOnlyInParentType(GestureDetector, "Next State".toUpperCase(), ActionButton);

    expect(
      gestureDetectorFinder,
      findsOneWidget,
      reason: "There are should be a GestureDetector inside ActionButton",
    );

    final GestureDetector gestureDetector = tester.firstWidget(gestureDetectorFinder);

    expect(
      gestureDetector.onTap,
      isNotNull,
      reason: "onTap parameter should be not null in GestureDetector",
    );

    expect(
      container.child,
      isInstanceOf<Text>(),
      reason: "Container should have child of Text type",
    );

    final Text text = container.child as Text;

    checkTextProperties(
      textWidget: text,
      textColor: const Color(0xFFFFFFFF),
      fontSize: 14,
      fontWeight: FontWeight.w700,
    );
  });
}
