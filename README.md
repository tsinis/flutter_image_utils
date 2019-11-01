# flutter_image_utils

[![pub package](https://img.shields.io/pub/v/flutter_image_utils.svg?style=flat-square)](https://pub.dartlang.org/packages/flutter_image_utils)

Crops image as native plugin, both iOS and Android

## Usage

[Full example](https://github.com/vanelizarov/flutter_image_utils/blob/master/example/lib/main.dart)

```yaml
# pubspec.yaml

dependencies:
  flutter_image_utils: ^1.0.0
```

```dart
// E.g. lib/main.dart

import 'dart:typed_data';
import 'package:flutter_image_utils/flutter_image_utils.dart';

/* ... */

final img = AssetImage('assets/some_image.jpg');
final config = new ImageConfiguration();

final key = await img.obtainKey(config);
final data = await key.bundle.load(key.name);

final imgBytes = data.buffer.asUint8List();

// All other methods can be used same way
final cropped = await FlutterImageUtils.cropImage(
  imgBytes,
  x: 0,
  y: 0,
  width: 50,
  height: 50,
  quality: 85,
  format: FlutterImageUtils.png,
);

/* ... */

MemoryImage(Uint8List.fromList(cropped))
```
