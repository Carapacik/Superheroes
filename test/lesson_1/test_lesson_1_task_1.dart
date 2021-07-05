import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:superheroes/main.dart';

import '../shared/test_helpers.dart';

void runTestLesson1Task1() {
  testWidgets('module1', (WidgetTester tester) async {

    await tester.pumpWidget(MyApp());

    final materialAppFinder = find.byType(MaterialApp);
    expect(
      materialAppFinder,
      findsOneWidget,
      reason: "There should be a MaterialApp widget in MyApp",
    );

    final MaterialApp materialApp = tester.widget<MaterialApp>(materialAppFinder);

    expect(
      materialApp.theme,
      isNotNull,
      reason: "You need to provide ThemeData in MaterialApp",
    );

    expect(
      materialApp.theme!.textTheme.bodyText1!.fontFamily,
      equals("OpenSans_regular"),
      reason: "Text theme should be equals to GoogleFonts.openSansTextTheme()",
    );
    
  });
}
