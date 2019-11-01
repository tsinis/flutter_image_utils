import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';

class FlutterImageUtils {
  static const MethodChannel _channel = const MethodChannel('flutter_image_utils');

  /// Returns `Future<Uint8List>` that contains bytes of cropped image.
  ///
  /// `x` and `y` params control the point from which the cropping
  /// will be performed.
  /// Must not be null or negative.
  ///
  /// `width` and `height` params control the width and the height
  /// of the cropping rect. They can be more than width and height
  /// of the original image, in this case platfrom code will constrain them
  /// to maximum possible.
  /// Must not be null or negative.
  ///
  /// `quality` param controls the quality of the output image. Must be
  /// positive number between `0` and `100`.
  ///
  /// ```dart
  /// import 'dart:typed_data';
  /// /* ... */
  /// final cropped = await FlutterImageUtils.cropImage(
  ///   imgBytes,
  ///   x: 0,
  ///   y: 0,
  ///   width: 50,
  ///   height: 50,
  ///   quality: 85,
  /// );
  /// /* ... */
  /// MemoryImage(cropped)
  /// ```
  static Future<Uint8List> cropImage(
    List<int> image, {
    int x,
    int y,
    int width,
    int height,
    int quality = 95,
  }) async {
    assert(image != null, 'image must not be null');

    assert(x != null, 'x must not be null');
    assert(y != null, 'y must not be null');
    assert(width != null, 'width must not be null');
    assert(height != null, 'height must not be null');
    assert(quality != null, 'quality must not be null');

    assert(x >= 0, 'x must be positive or equal to zero');
    assert(y >= 0, 'y must be positive or equal to zero');
    assert(width >= 0, 'width must be positive or equal to zero');
    assert(height >= 0, 'height must be positive or equal to zero');
    assert(quality >= 0, 'quality must be positive or equal to zero');

    if (image == null) {
      return Uint8List(0);
    }

    if (image.isEmpty) {
      return Uint8List(0);
    }

    final result = await _channel.invokeMethod('crop', <String, dynamic>{
      'bytes': Uint8List.fromList(image),
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      'quality': quality,
    });

    if (result == null || result.isEmpty) {
      return Uint8List(0);
    }

    return _convertDynamic(result);
  }

  /// Returns `Future<Uint8List>` that contains bytes of proportionally scaled image.
  ///
  /// `maxSize` param controls max size to which image will be scaled
  /// E.g. if the image has size 1400x700 pixels and `maxSize` is set to 1200
  /// the size of the resulting image will be 1200x600
  /// Must not be null or negative.
  ///
  /// `quality` param controls the quality of the output image. Must be
  /// positive number between `0` and `100`.
  ///
  /// ```dart
  /// import 'dart:typed_data';
  /// /* ... */
  /// final sized = await FlutterImageUtils.resizeImageToMax(
  ///   imgBytes,
  ///   maxSize: 1200,
  ///   quality: 85,
  /// );
  /// /* ... */
  /// MemoryImage(sized)
  /// ```
  static Future<Uint8List> resizeImageToMax(
    List<int> image, {
    int maxSize,
    int quality = 95,
  }) async {
    assert(image != null, 'image must not be null');

    assert(maxSize != null, 'maxSize must not be null');
    assert(quality != null, 'quality must not be null');

    assert(maxSize >= 0, 'maxSize must be positive or equal to zero');
    assert(quality >= 0, 'quality must be positive or equal to zero');

    if (image == null) {
      return Uint8List(0);
    }

    if (image.isEmpty) {
      return Uint8List(0);
    }

    final result = await _channel.invokeMethod('resizeToMax', <String, dynamic>{
      'bytes': Uint8List.fromList(image),
      'maxSize': maxSize,
      'quality': quality,
    });

    if (result == null || result.isEmpty) {
      return Uint8List(0);
    }

    return _convertDynamic(result);
  }

  /// Returns `Future<Uint8List>` that contains bytes of resized image.
  ///
  /// `destWidth` and `destHeight` params control dimensions to which image will be scaled
  /// Must not be null or negative.
  ///
  /// `quality` param controls the quality of the output image. Must be
  /// positive number between `0` and `100`.
  ///
  /// ```dart
  /// import 'dart:typed_data';
  /// /* ... */
  /// final sized = await FlutterImageUtils.resizeImage(
  ///   imgBytes,
  ///   destWidth: 1200,
  ///   destWidth: 600,
  ///   quality: 85,
  /// );
  /// /* ... */
  /// MemoryImage(sized)
  /// ```
  static Future<Uint8List> resizeImage(
    List<int> image, {
    int destWidth,
    int destHeight,
    int quality = 95,
  }) async {
    assert(image != null, 'image must not be null');

    assert(destWidth != null, 'destWidth must not be null');
    assert(destHeight != null, 'destHeight must not be null');
    assert(quality != null, 'quality must not be null');

    assert(destWidth >= 0, 'destWidth must be positive or equal to zero');
    assert(destHeight >= 0, 'destHeight must be positive or equal to zero');
    assert(quality >= 0, 'quality must be positive or equal to zero');

    if (image == null) {
      return Uint8List(0);
    }

    if (image.isEmpty) {
      return Uint8List(0);
    }

    final result = await _channel.invokeMethod('resize', <String, dynamic>{
      'bytes': Uint8List.fromList(image),
      'destWidth': destWidth,
      'destHeight': destHeight,
      'quality': quality,
    });

    if (result == null || result.isEmpty) {
      return Uint8List(0);
    }

    return _convertDynamic(result);
  }

  /// Returns `Future<Uint8List>` that contains bytes of rotated image.
  ///
  /// `angle` param controls angle by which image will be rotated
  /// Must not be null or negative.
  ///
  /// `quality` param controls the quality of the output image. Must be
  /// positive number between `0` and `100`.
  ///
  /// ```dart
  /// import 'dart:typed_data';
  /// /* ... */
  /// final rotated = await FlutterImageUtils.rotateImage(
  ///   imgBytes,
  ///   angle: 90,
  ///   quality: 85,
  /// );
  /// /* ... */
  /// MemoryImage(rotated)
  /// ```
  static Future<Uint8List> rotateImage(
    List<int> image, {
    int angle,
    int quality = 95,
  }) async {
    assert(image != null, 'image must not be null');

    assert(angle != null, 'angle must not be null');
    assert(quality != null, 'quality must not be null');

    assert(quality >= 0, 'quality must be positive or equal to zero');

    if (image == null) {
      return Uint8List(0);
    }

    if (image.isEmpty) {
      return Uint8List(0);
    }

    final result = await _channel.invokeMethod('rotate', <String, dynamic>{
      'bytes': Uint8List.fromList(image),
      'angle': angle,
      'quality': quality,
    });

    if (result == null || result.isEmpty) {
      return Uint8List(0);
    }

    return _convertDynamic(result);
  }

  static Uint8List _convertDynamic(List<dynamic> list) {
    if (list == null || list.isEmpty) {
      return Uint8List(0);
    }

    return Uint8List.fromList(
        list.where((item) => item is int).map((item) => item as int).toList());
  }
}
