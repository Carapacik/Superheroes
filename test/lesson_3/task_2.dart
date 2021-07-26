import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/widgets/superhero_card.dart';

///
/// 2. Показывать индикатор загрузки картинки
///     1. Внутри CachedNetworkImage во время загрузки изображения показывать
///        круговой индикатор с загрузкой.
///     2. Круговой индикатор должен располагаться по центру квадрата
///     3. Круговой индикатор должен быть цвета как на макете (голубой)
///     4. Размер индикатора должен быть размером 24 на 24
///     5. Виджет с прогрессом должен быть определенным (determinate), если
///        прогресс загрузки изображения не равен null.
///     6. Виджет с прогрессом должен быть неопределенным (indeterminate), если
///        прогресс загрузки изображения равен null.
///
void runTestLesson3Task2() {
  testWidgets('module2', (WidgetTester tester) async {
    await tester.runAsync(() async {
      final batmanSuperheroInfo = SuperheroInfo(
        name: "Batman",
        realName: "Bruce Wayne",
        imageUrl:
            "https://www.superherodb.com/pictures2/portraits/10/100/639.jpg",
      );
      final card =
          SuperheroCard(superheroInfo: batmanSuperheroInfo, onTap: () {});
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

      final cachedNetworkImage =
          tester.widget<CachedNetworkImage>(cachedNetworkImageFinder);
      expect(
        cachedNetworkImage.progressIndicatorBuilder,
        isNotNull,
        reason:
            "progressIndicatorBuilder property in CachedNetworkImage shouldn't be null",
      );

      await tester.pumpWidget(
        Material(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Builder(
              builder: (context) =>
                  cachedNetworkImage.progressIndicatorBuilder!(
                context,
                "https://www.superherodb.com/pictures2/portraits/10/100/639.jpg",
                DownloadProgress(
                    "https://www.superherodb.com/pictures2/portraits/10/100/639.jpg",
                    100,
                    50),
              ),
            ),
          ),
        ),
      );

      expect(
        find.byType(CircularProgressIndicator),
        findsOneWidget,
        reason:
            "Expected to find CircularProgressIndicator during image loading",
      );

      await tester.pump(const Duration(milliseconds: 1));
      expect(
        tester.hasRunningAnimations,
        isFalse,
        reason:
            "CircularProgressIndicator should be determinate and show current download progress if progress is available",
      );

      await tester.pumpWidget(
        Material(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Builder(
              builder: (context) =>
                  cachedNetworkImage.progressIndicatorBuilder!(
                context,
                "https://www.superherodb.com/pictures2/portraits/10/100/639.jpg",
                DownloadProgress(
                    "https://www.superherodb.com/pictures2/portraits/10/100/639.jpg",
                    null,
                    50),
              ),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 1));
      expect(
        tester.hasRunningAnimations,
        isTrue,
        reason:
            "CircularProgressIndicator should be indeterminate if there are no progress available",
      );
    });
  });
}
