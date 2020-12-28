/*
 *  radio_player.dart
 *
 *  Created by Ilya Chirkunov <xc@yar.net> on 28.12.2020.
 */

import 'dart:async';
import 'package:flutter/services.dart';

class RadioPlayer {
  final String streamTitle;
  final String streamCover;
  final String streamURL;
  static const MethodChannel _channel = const MethodChannel('radio_player');

  RadioPlayer(this.streamTitle, this.streamCover, this.streamURL);

  Future<void> play() async {
    await _channel.invokeMethod('play');
  }

  Future<void> pause() async {
    await _channel.invokeMethod('pause');
  }
}
