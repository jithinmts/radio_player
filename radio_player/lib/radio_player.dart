/*
 *  radio_player.dart
 *
 *  Created by Ilya Chirkunov <xc@yar.net> on 28.12.2020.
 */

import 'dart:async';
import 'package:flutter/services.dart';

/// Plays a radio stream using AVPlayer for iOS and ExoPlayer for Android.
/// Supports the playback state and metadata stream.
class RadioPlayer {
  static const MethodChannel _channel = MethodChannel('radio_player');

  RadioPlayer(String streamTitle, String streamUrl) {
    _channel.invokeMethod('init', <dynamic>[streamTitle, streamUrl]);
  }

  Future<void> play() async {
    await _channel.invokeMethod('play');
  }

  Future<void> pause() async {
    await _channel.invokeMethod('pause');
  }
}
