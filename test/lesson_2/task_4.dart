import 'package:flutter_test/flutter_test.dart';
import 'package:superheroes/blocs/main_bloc.dart';

///
/// 4. Реализовать логику поиска супергероев (1 балл)
///    Доделать метод search в блоке, чтобы он реально фильтровал mocked
///    супергероев по введенной строке
///
/// - Возвращать все SuperheroInfo из mock списка, которые внутри параметра name
///   содержат в себе поисковую строку
/// - Регистр поисковой строки не должен влиять на результат. То есть результаты
///   поиска не должны отличаться для поисковых строк 'MAN', 'man' и 'Man'.
///
void runTestLesson2Task4() {
  testWidgets('module4', (WidgetTester tester) async {
    await tester.runAsync(() async {
      final batman = SuperheroInfo(
        name: "Batman",
        realName: "Bruce Wayne",
        imageUrl: "https://www.superherodb.com/pictures2/portraits/10/100/639.jpg",
      );
      final ironman = SuperheroInfo(
        name: "Ironman",
        realName: "Tony Stark",
        imageUrl: "https://www.superherodb.com/pictures2/portraits/10/100/85.jpg",
      );
      final MainBloc bloc = MainBloc();
      expect(
        bloc.search("batm"),
        completion(equals([batman])),
        reason: "Searching 'batm' should return only info about Batman",
      );
      expect(
        bloc.search("BATM"),
        completion(equals([batman])),
        reason: "Searching 'BATM' should return only info about Batman",
      );
      expect(
        bloc.search("Batm"),
        completion(equals([batman])),
        reason: "Searching 'Batm' should return only info about Batman",
      );
      expect(
        bloc.search("man"),
        completion(equals([batman, ironman])),
        reason: "Searching 'man' should return info about Batman and Ironman",
      );
      expect(
        bloc.search("MAN"),
        completion(equals([batman, ironman])),
        reason: "Searching 'MAN' should return info about Batman and Ironman",
      );
      expect(
        bloc.search("Tony"),
        completion(equals([])),
        reason: "Searching 'Tony' should return nothing",
      );
    });
  });
}
