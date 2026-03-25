import 'dart:async';

import 'package:flutter/foundation.dart';

class CountdownTimerNotifier extends ChangeNotifier {
  CountdownTimerNotifier({required int initialSeconds})
      : _initialSeconds = initialSeconds,
        _secondsRemaining = initialSeconds;

  final int _initialSeconds;
  int _secondsRemaining;
  int get secondsRemaining => _secondsRemaining;

  Timer? _timer;

  bool get canResend => _secondsRemaining <= 0;

  void start() {
    _timer?.cancel();
    _secondsRemaining = _initialSeconds;
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsRemaining <= 0) {
        t.cancel();
        notifyListeners();
        return;
      }

      _secondsRemaining -= 1;
      notifyListeners();
    });
  }

  void restart() => start();

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
