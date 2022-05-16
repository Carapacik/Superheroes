import 'dart:ui';

import 'package:superheroes/resources/app_colors.dart';

enum AlignmentInfo {
  bad._('bad', AppColors.red),
  neutral._('neutral', AppColors.grey),
  good._('good', AppColors.green);

  const AlignmentInfo._(this.name, this.color);

  final String name;
  final Color color;

  static AlignmentInfo? fromAlignment(final String alignment) {
    if (alignment == 'bad') {
      return bad;
    } else if (alignment == 'good') {
      return good;
    } else if (alignment == 'neutral') {
      return neutral;
    }
    return null;
  }
}
