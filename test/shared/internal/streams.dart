import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

final _initialItem = null;

Future<void> expectEmitsInOrderWithTimeoutAndThenDone<T>(
  Stream<T> actual,
  List<T> matcher, {
  String? reason,
  Duration bufferTime = const Duration(seconds: 1),
}) {
  return expectLater(
    actual
        .map<T?>((event) => event)
        .startWith(_initialItem as T?)
        .bufferTime(bufferTime)
        .take(1),
    emits([_initialItem, ...matcher]),
    reason: reason,
  );
}
