import 'package:flutter/foundation.dart';

class OtpNotifier extends ChangeNotifier {
  OtpNotifier({required this.length});

  final int length;

  String _code = '';
  String get code => _code;

  bool get isComplete => _code.length == length;

  void setCode(String value) {
    if (value == _code) return;
    _code = value;
    notifyListeners();
  }

  void clear() {
    if (_code.isEmpty) return;
    _code = '';
    notifyListeners();
  }
}
