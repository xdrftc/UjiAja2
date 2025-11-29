// lib/utils/timer_controller.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

class TimerController extends ValueNotifier<int> {
  TimerController(int initialSeconds) : super(initialSeconds);
  late final Ticker _ticker;

  void start() {
    _ticker = Ticker((_) {
      if (value > 0) {
        value--;
      } else {
        _ticker.stop();
      }
    });
    _ticker.start();
  }

  void stop() => _ticker.stop();

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}
