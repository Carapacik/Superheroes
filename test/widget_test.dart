import 'package:flutter_test/flutter_test.dart';

import 'lesson_2/task_1.dart';
import 'lesson_2/task_2.dart';
import 'lesson_2/task_3.dart';
import 'lesson_2/task_4.dart';

void main() {
  group("l06h01", () => runTestLesson2Task1());
  group("l06h02", () => runTestLesson2Task2());
  group("l06h03", () => runTestLesson2Task3());
  group("l06h04", () => runTestLesson2Task4());
}
