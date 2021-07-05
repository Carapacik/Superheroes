import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/main.dart';

import '../shared/test_helpers.dart';
import 'shared.dart';


void runTestLesson1Task3() {
  testWidgets('module3', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();

    await reachNeededState(tester, MainPageState.minSymbols);

    final alignFinder = findTypeByTextOnlyInParentType(Align, "Enter at least 3 symbols", Stack);
    expect(
      alignFinder,
      findsOneWidget,
      reason: "There should be an Align inside Stack with text inside 'Enter at least 3 symbols'",
    );

    final Align align = tester.firstWidget(alignFinder);
    expect(
      align.alignment,
      Alignment.topCenter,
      reason: "Align should have Alignment.topCenter alignment property",
    );

    final paddingFinder =
        findTypeByTextOnlyInParentType(Padding, "Enter at least 3 symbols", Align);
    expect(
      paddingFinder,
      findsOneWidget,
      reason: "There should be a Padding inside Align",
    );

    final Padding padding = tester.firstWidget(paddingFinder);
    checkEdgeInsetParam(
      widgetName: "Padding",
      param: padding.padding,
      paramName: "",
      edgeInsetsCheck: EdgeInsetsCheck(top: 110),
    );

    final textFinder = find.text("Enter at least 3 symbols");
    expect(
      textFinder,
      findsOneWidget,
      reason: "There should be a Text with text 'Enter at least 3 symbols'",
    );

    final Text text = tester.firstWidget(textFinder);
    checkTextProperties(
      textWidget: text,
      textColor: const Color(0xFFFFFFFF),
      fontSize: 20,
      fontWeight: FontWeight.w600,
    );
  });
}
