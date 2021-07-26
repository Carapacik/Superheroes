import 'package:flutter_test/flutter_test.dart';
import 'package:superheroes/model/biography.dart';
import 'package:superheroes/model/powerstats.dart';
import 'package:superheroes/model/superhero.dart';

///
/// 4. Обновления в моделях данных
///     1. Biography
///         1. Добавить поле alignment типа String в модель Biography. После
///            добавления, перегенерировать вспомогательные классы для моделей
///         2. В JsonSerializable аннотации к классу добавить флаг
///            explicitToJson: true
///     2. Powerstats
///         1. Создать новый файл powerstats.dart и положить его в папку model
///         2. Внутри powerstats.dart создать класс Powerstats
///         3. Powerstats должен содержать 6 полей с названиями,
///            соответствующими тому, что возвращает сервер.
///         4. Все поля должны иметь тип String
///         5. Сгенерировать методы toJson и fromJson с помощью кодогенерации
///         6. В JsonSerializable аннотации к классу добавить флаг
///            explicitToJson: true
///     3. Superhero
///         1. Добавить поле powerstats типа Powerstats.
///         2. Добавить поле id типа String
///         3. В JsonSerializable аннотации к классу добавить флаг
///            explicitToJson: true
///     4. ServerImage
///         1. В JsonSerializable аннотации к классу добавить флаг
///            explicitToJson: true
///     5. Перегенерировать файлы через build_runner, используя команду
///        flutter pub run build_runner build
///     6. Ответ от API должен корректно декодироваться в модели данных
///     7. Другие поля кроме указанных добавлять не надо
///
void runTestLesson3Task4() {
  testWidgets('module4', (WidgetTester tester) async {
    final Powerstats powerstats1 = Powerstats.fromJson(powerstatsMock1);
    final Map<String, dynamic> powerstats1JsonReversed = powerstats1.toJson();
    expect(
      powerstatsMock1,
      powerstats1JsonReversed,
      reason:
          "Powerstats should convert itself via toJson() method to Map<String, dynamic> correctly",
    );
    final Powerstats powerstats2 = Powerstats.fromJson(powerstatsMock2);
    final Map<String, dynamic> powerstats2JsonReversed = powerstats2.toJson();
    expect(
      powerstatsMock2,
      powerstats2JsonReversed,
      reason:
          "Powerstats should convert itself via toJson() method to Map<String, dynamic> correctly",
    );

    final Biography biography1 = Biography.fromJson(biographyMock1);
    final Map<String, dynamic> biography1JsonReversed = biography1.toJson();
    expect(
      biographyMock1,
      biography1JsonReversed,
      reason:
          "Biography should convert itself via toJson() method to Map<String, dynamic> correctly",
    );

    final Superhero superhero = Superhero.fromJson(batmaResponse);
    final Map<String, dynamic> superheroJsonReversed = superhero.toJson();

    expect(
      superheroJsonReversed,
      batmaResponseReversed,
      reason:
          "Superhero should convert itself via toJson() method to Map<String, dynamic> correctly",
    );
  });
}

final powerstatsMock1 = {
  "intelligence": "100",
  "strength": "26",
  "speed": "27",
  "durability": "50",
  "power": "47",
  "combat": "100"
};

final powerstatsMock2 = {
  "intelligence": "null",
  "strength": "null",
  "speed": "null",
  "durability": "null",
  "power": "null",
  "combat": "null"
};

final biographyMock1 = {"full-name": "Terry McGinnis", "alignment": "good"};

final batmaResponse = {
  "id": "69",
  "name": "Batman",
  "powerstats": {
    "intelligence": "81",
    "strength": "40",
    "speed": "29",
    "durability": "55",
    "power": "63",
    "combat": "90"
  },
  "biography": {
    "full-name": "Terry McGinnis",
    "alter-egos": "No alter egos found.",
    "aliases": [
      "Batman II",
      "The Tomorrow Knight",
      "The second Dark Knight",
      "The Dark Knight of Tomorrow",
      "Batman Beyond"
    ],
    "place-of-birth": "Gotham City, 25th Century",
    "first-appearance": "Batman Beyond #1",
    "publisher": "DC Comics",
    "alignment": "good"
  },
  "appearance": {
    "gender": "Male",
    "race": "Human",
    "height": ["5'10", "178 cm"],
    "weight": ["170 lb", "77 kg"],
    "eye-color": "Blue",
    "hair-color": "Black"
  },
  "work": {"occupation": "-", "base": "21st Century Gotham City"},
  "connections": {
    "group-affiliation": "Batman Family, Justice League Unlimited",
    "relatives":
        "Bruce Wayne (biological father), Warren McGinnis (father, deceased), Mary McGinnis (mother), Matt McGinnis (brother)"
  },
  "image": {
    "url": "https://www.superherodb.com/pictures2/portraits/10/100/10441.jpg"
  }
};

final batmaResponseReversed = {
  "id": "69",
  "name": "Batman",
  "powerstats": {
    "intelligence": "81",
    "strength": "40",
    "speed": "29",
    "durability": "55",
    "power": "63",
    "combat": "90"
  },
  "biography": {"full-name": "Terry McGinnis", "alignment": "good"},
  "image": {
    "url": "https://www.superherodb.com/pictures2/portraits/10/100/10441.jpg"
  }
};

final errorResponse = {
  "response": "error",
  "error": "character with given name not found"
};
