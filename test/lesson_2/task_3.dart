import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:superheroes/main.dart';

import '../shared/test_helpers.dart';

///
/// 3. Стилизация поля для поиска (2 балла)
///    Стилизовать TextField сообразно макетам в Figma
///
/// - Показывать белую границу при редактировании текста. Толщина 2, цвет 100%
///   белый.
/// - Поменять цвет курсора на белый.
/// - Изменить кнопку на клавиатуре. Кнопка должна быть про поиск, а не про done
/// - Первый введенный символ каждого слова должен становиться с большой буквы
///
void runTestLesson2Task3() {
  testWidgets('module3', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();

    final textFieldFinder = find.byType(TextField);

    expect(
      textFieldFinder,
      findsOneWidget,
      reason: "There should be a TextField widget on the main screen",
    );

    final TextField textField = tester.widget(textFieldFinder);

    checkTextFieldBorders(
      textField: textField,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.white, width: 2),
      ),
    );

    checkTextFieldCursorColor(
      textField: textField,
      cursorColor: Colors.white,
    );

    checkTextFieldTextInputAction(
      textField: textField,
      textInputAction: TextInputAction.search,
    );

    checkTextFieldTextCapitalization(
      textField: textField,
      textCapitalization: TextCapitalization.words,
    );
  });
}
