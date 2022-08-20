import 'dart:ui';

import 'package:superheroes/resources/colors.dart';

enum AlignmentEnum {
  bad(AppColors.red),
  neutral(AppColors.grey),
  good(AppColors.green);

  const AlignmentEnum(this.color);

  final Color color;
}
