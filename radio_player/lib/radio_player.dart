/*
 *  radio_player.dart
 *
 *  Created by Ilya Chirkunov <xc@yar.net> on 28.12.2020.
 */

import 'dart:async';
import 'package:flutter/services.dart';

/// Plays a radio stream using AVPlayer for iOS and MediaPlayer for Android.
/// Supports the playback state and metadata stream.
class RadioPlayer {
  static const MethodChannel _channel = const MethodChannel('radio_player');

  Future<void> init(String streamTitle, String streamURL) async {
    await _channel.invokeMethod('init');
  }

  Future<void> play() async {
    await _channel.invokeMethod('play');
  }

  Future<void> pause() async {
    await _channel.invokeMethod('pause');
  }
}
