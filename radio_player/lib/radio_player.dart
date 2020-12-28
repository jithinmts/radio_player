
import 'dart:async';

import 'package:flutter/services.dart';

class RadioPlayer {
  static const MethodChannel _channel =
      const MethodChannel('radio_player');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
