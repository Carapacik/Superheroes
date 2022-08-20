import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:superheroes/app.dart';
import 'package:url_strategy/url_strategy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  setPathUrlStrategy();
  runApp(const App());
}
