
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import 'lesson_4/task_1.dart';
import 'lesson_4/task_2.dart';
import 'lesson_4/task_3.dart';
import 'lesson_4/task_4.dart';
import 'lesson_4/task_7.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await loadAppFonts();
  await dotenv.load(fileName: ".env");
  group("l08h01", () => runTestLesson4Task1());
  group("l08h02", () => runTestLesson4Task2());
  group("l08h03", () => runTestLesson4Task3());
  group("l08h04", () => runTestLesson4Task4());
  group("l08h07", () => runTestLesson4Task7());
}
