/*
 *  radio_player.dart
 *
 *  Created by Ilya Chirkunov <xc@yar.net> on 28.12.2020.
 */

import 'dart:async';
import 'package:flutter/services.dart';

class RadioPlayer {
  static const _channel = MethodChannel('radio_player');
  static const _metadataEvents = EventChannel('radio_player/metadataEvents');
  static const _stateEvents = EventChannel('radio_player/stateEvents');

  Stream<bool>? _stateStream;
  Stream<List<String>>? _metadataStream;

  Future<void> setMediaItem(String title, String url) async {
    await _channel.invokeMethod('set', <dynamic>[title, url]);
  }

  Future<void> play() async {
    await _channel.invokeMethod('play');
  }

  Future<void> pause() async {
    await _channel.invokeMethod('pause');
  }

  /// Get the playback state stream.
  Stream<bool> get stateStream {
    _stateStream ??=
        _stateEvents.receiveBroadcastStream().map<bool>((value) => value);

    return _stateStream!;
  }

  /// Get the metadata stream.
  Stream<List<String>> get metadataStream {
    _metadataStream ??=
        _metadataEvents.receiveBroadcastStream().map((metadata) {
      return metadata.map<String>((value) => value as String).toList();
    });

    return _metadataStream!;
  }
}
