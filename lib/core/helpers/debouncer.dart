import 'dart:async';
import 'package:flutter/material.dart';

class Debouncer {
  final Duration delay;
  Timer? _timer;
  DateTime? _lastCall;

  Debouncer({this.delay = const Duration(milliseconds: 500)});

  bool get canCall {
    if (_lastCall == null) return true;
    return DateTime.now().difference(_lastCall!) > delay;
  }

  void call(VoidCallback action) {
    _timer?.cancel();
    if (canCall) {
      _lastCall = DateTime.now();
      action();
    } else {
      _timer = Timer(delay, () {
        _lastCall = DateTime.now();
        action();
      });
    }
  }

  void dispose() {
    _timer?.cancel();
  }
}
