/*
 *  main.dart
 *
 *  Created by Ilya Chirkunov <xc@yar.net> on 28.12.2020.
 */

import 'package:flutter/material.dart';
import 'package:radio_player/radio_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  RadioPlayer _radioPlayer = RadioPlayer();
  bool isPlaying = false;
  List<String>? metadata;

  @override
  void initState() {
    super.initState();
    initRadioPlayer();
  }

  void initRadioPlayer() {
    _radioPlayer.setMediaItem('Radio Player', 'https://myradio24.org/2288.m3u');

    _radioPlayer.stateStream.listen((value) {
      setState(() {
        isPlaying = value;
      });
    });

    _radioPlayer.metadataStream.listen((value) {
      setState(() {
        metadata = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Radio Player'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                metadata?[0] ?? 'Metadata',
                softWrap: false,
                overflow: TextOverflow.fade,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              Text(
                metadata?[1] ?? '',
                softWrap: false,
                overflow: TextOverflow.fade,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            isPlaying ? _radioPlayer.pause() : _radioPlayer.play();
          },
          tooltip: 'Increment',
          child: Icon(
            isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
          ),
        ),
      ),
    );
  }
}
