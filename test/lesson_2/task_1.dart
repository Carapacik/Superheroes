import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:rxdart/rxdart.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/pages/main_page.dart';

///
/// 1. Скрывать клавиатуру (1 балл)
///    Автоматически скрывать клавиатуру при скролле
///
/// - Сделать так, чтобы при скролле пропадала клавиатура с помощью методов
///   ListView. Использовать определенный параметр у ListView
///
void runTestLesson2Task1() {
  testWidgets('module1', (WidgetTester tester) async {
    await mockNetworkImagesFor(() async {
      await tester.runAsync(() async {
        final subject = BehaviorSubject<List<SuperheroInfo>>.seeded(SuperheroInfo.mocked);
        await tester.pumpWidget(
            MaterialApp(home: SuperheroesList(title: "Your favorites", stream: subject)));

        await tester.pump(Duration(milliseconds: 1));

        final listViewFinder = find.byType(ListView);
        expect(
          listViewFinder,
          findsOneWidget,
          reason: "There should be a ListView on the main screen",
        );

        final ListView listView = tester.widget(listViewFinder);
        expect(
          listView.keyboardDismissBehavior,
          ScrollViewKeyboardDismissBehavior.onDrag,
          reason:
              "There are no appropriate parameters added in ListView to hide keyboard on scroll",
        );

        await subject.close();
      });
    });
  });
}
