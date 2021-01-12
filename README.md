# Radio Player

A Flutter plugin to play streaming audio content.

[![flutter platform](https://img.shields.io/badge/Platform-Flutter-yellow.svg)](https://flutter.io)
[![pub package](https://img.shields.io/pub/v/radio_player.svg)](https://pub.dartlang.org/packages/radio_player)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Installation

To use this package, add `radio_player` as a dependency in your `pubspec.yaml` file.

```yaml
dependencies:
  radio_player: ^0.0.1
```

Only for debug mode in iOS 14 or later add the following to info.plist

```
<key>NSBonjourServices</key>
<array>
<string>_dartobservatory._tcp</string>
</array>
```

## Example

```dart
import 'package:flutter/material.dart';
import 'package:radio_player/radio_player.dart';

...
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
Please make sure to update tests as appropriate.
