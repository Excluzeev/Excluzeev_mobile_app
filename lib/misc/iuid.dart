import 'dart:math';

// https://raw.githubusercontent.com/flutter/plugins/master/packages/cloud_firestore/lib/src/utils/push_id_generator.dart

class IUID {
  static const String PUSH_CHARS =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';

  static const int LENGTH = PUSH_CHARS.length;

  static final Random _random = Random();

  static int _lastPushTime;

  static final List<int> _lastRandChars = List<int>(12);

  static String get string {
    int now = DateTime.now().millisecondsSinceEpoch;
    final bool duplicateTime = (now == _lastPushTime);
    _lastPushTime = now;

    final List<String> timeStampChars = List<String>(8);
    for (int i = 7; i >= 0; i--) {
      timeStampChars[i] = PUSH_CHARS[now % LENGTH];
      now = (now / LENGTH).floor();
    }
    assert(now >= 0);

    final StringBuffer result = StringBuffer(timeStampChars.join());

    if (!duplicateTime) {
      for (int i = 0; i < 12; i++) {
        _lastRandChars[i] = _random.nextInt(LENGTH);
      }
    } else {
      _incrementArray();
    }
    for (int i = 0; i < 12; i++) {
      result.write(PUSH_CHARS[_lastRandChars[i]]);
    }
    assert(result.length == 20);
    return result.toString();
  }

  static void _incrementArray() {
    for (int i = 11; i >= 0; i--) {
      if (_lastRandChars[i] != LENGTH - 1) {
        _lastRandChars[i] = _lastRandChars[i] + 1;
        return;
      }
      _lastRandChars[i] = 0;
    }
  }
}
