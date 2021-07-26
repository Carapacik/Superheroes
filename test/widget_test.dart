import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

import 'lesson_3/task_1.dart';
import 'lesson_3/task_2.dart';
import 'lesson_3/task_3.dart';
import 'lesson_3/task_4.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  group("l07h01", () => runTestLesson3Task1());
  group("l07h02", () => runTestLesson3Task2());
  group("l07h03", () => runTestLesson3Task3());
  group("l07h04", () => runTestLesson3Task4());
}
