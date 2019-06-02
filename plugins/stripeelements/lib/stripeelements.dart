import 'dart:async';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

class Stripeelements {
  static const MethodChannel _channel =
      const MethodChannel('stripeelements');

  static const EventChannel _stream =
  const EventChannel('stripeelements_stream');

  enterCardDetails({@required String key}) {

    final Map<String, dynamic> params = <String, dynamic>{
      'key': key,
    };
    _channel.invokeMethod('card', params);

  }

  Stream<String> get onToken {
    var d = _stream.receiveBroadcastStream().map<String>((element) => element);
    return d;
  }
}
