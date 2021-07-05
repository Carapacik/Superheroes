import 'package:flutter_test/flutter_test.dart';
import 'package:superheroes/blocs/main_bloc.dart';

Future<void> reachNeededState(
  final WidgetTester tester,
  final MainPageState state, {
  final MainPageState startingState = MainPageState.noFavorites,
}) async {
  final int currentStep = MainPageState.values.indexOf(startingState);
  final int steps = MainPageState.values.indexOf(state) - currentStep;
  for (int i = 0; i < steps; i++) {
    await tester.tap(find.text("NEXT STATE"));
    await tester.pump();
  }
}
