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
        imageUrl:
            "https://www.superherodb.com/pictures2/portraits/10/100/639.jpg",
      );
      final ironman = SuperheroInfo(
        name: "Ironman",
        realName: "Tony Stark",
        imageUrl:
            "https://www.superherodb.com/pictures2/portraits/10/100/85.jpg",
      );
      final venom = SuperheroInfo(
        name: "Venom",
        realName: "Eddie Brock",
        imageUrl:
            'https://www.superherodb.com/pictures2/portraits/10/100/22.jpg',
      );
      final MainBloc bloc = MainBloc();
      expect(
        await bloc.search("batm"),
        [batman],
        reason: "Searching 'batm' should return info about Batman",
      );
      expect(
        await bloc.search("BATM"),
        [batman],
        reason: "Searching 'BATM' should return info about Batman",
      );
      expect(
        await bloc.search("Batm"),
        [batman],
        reason: "Searching 'Batm' should return info about Batman",
      );
      expect(
        await bloc.search("man"),
        [batman, ironman],
        reason: "Searching 'man' should return info about Batman and Ironman",
      );
      expect(
        await bloc.search("MAN"),
        [batman, ironman],
        reason: "Searching 'MAN' should return info about Batman and Ironman",
      );
      expect(
        await bloc.search("maN"),
        [batman, ironman],
        reason: "Searching 'maN' should return info about Batman and Ironman",
      );
      expect(
        await bloc.search("veNOm"),
        [venom],
        reason: "Searching 'veNOm' should return info about Venom",
      );
      expect(
        await bloc.search("Tony"),
        [],
        reason: "Searching 'Tony' should return nothing",
      );
      expect(
        await bloc.search("Eddie"),
        [],
        reason: "Searching 'Eddie' should return nothing",
      );
    });
  });
}
