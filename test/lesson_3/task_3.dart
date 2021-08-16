import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/widgets/superhero_card.dart';

import '../shared/internal/image_checks.dart';

///
/// 3. Показывать виджет-заглушку для CachedNetworkImage
///     1. В случае возникновения ошибки загрузки
///     2. Сохранить картинку из Figma с человечком с вопросительным знаком на
///       груди в assets в папку images
///     3. Добавить путь до картинки в superheroes_images.dart
///     4. Добавить в CachedNetworkImage (внутри SuperheroCard) билдер для
///        виджета, показывающийся в случае ошибки
///     5. Виджет должен состоять из двух виджетов: виджет Center, у которого
///        внутри Image, покзывающий картинку unknown из ассетов.
///     6. Протестировать ошибку загрузки можно если поискать супергероев
///        Redeemer
///
void runTestLesson3Task3() {
  testWidgets('module3', (WidgetTester tester) async {
    await tester.runAsync(() async {
      final batmanSuperheroInfo = SuperheroInfo(
        name: "Batman",
        realName: "Bruce Wayne",
        imageUrl: "https://www.superherodb.com/pictures2/portraits/10/100/639.jpg",
      );
      final card = SuperheroCard(superheroInfo: batmanSuperheroInfo, onTap: () {});
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Material(child: card),
        ),
      );

      final cachedNetworkImageFinder = find.byType(CachedNetworkImage);
      expect(
        cachedNetworkImageFinder,
        findsOneWidget,
        reason: "Expected to find one CachedNetworkImage inside SuperheroCard",
      );

      final cachedNetworkImage = tester.widget<CachedNetworkImage>(cachedNetworkImageFinder);

      expect(
        cachedNetworkImage.errorWidget,
        isNotNull,
        reason: "errorWidget property in CachedNetworkImage shouldn't be null",
      );

      await tester.pumpWidget(
        Material(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Builder(
              builder: (context) => cachedNetworkImage.errorWidget!(
                context,
                "https://www.superherodb.com/pictures2/portraits/10/100/639.jpg",
                Exception(),
              ),
            ),
          ),
        ),
      );

      final centerFinder = find.byType(Center);

      expect(
        find.byType(Center),
        findsOneWidget,
        reason: "Expected to find Center if error happened during image loading",
      );

      final Center center = tester.widget(centerFinder);

      expect(
        center.child,
        isNotNull,
        reason: "Center should have not null child",
      );

      expect(
        center.child,
        isInstanceOf<Image>(),
        reason: "Center should have an Image as a child",
      );

      final Image image = center.child as Image;

      checkImageProperties(
        image: image,
        width: 20,
        height: 62,
        imageProvider: AssetImage("assets/images/unknown.png"),
      );
    });
  });
}
