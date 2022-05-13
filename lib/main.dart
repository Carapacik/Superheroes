import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:superheroes/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const App());
}
