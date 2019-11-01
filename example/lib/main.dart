import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_image_utils/flutter_image_utils.dart';

import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Uint8List _imgBytes;
  Uint8List _processedBytes;
  int _x = 0;
  int _y = 0;
  int _dw = 0;
  int _dh = 0;
  int _sw = 0;
  int _sh = 0;
  int _quality = 100;
  int _format = FlutterImageUtils.jpeg;

  bool _isProcessing = false;
  int _processTime;

  Future<void> _pickImage(ImageSource source) async {
    final file = await ImagePicker.pickImage(source: source);

    if (file == null) {
      return;
    }

    final bytes = await file.readAsBytes();
    final uint8Bytes = Uint8List.fromList(bytes);

    final provider = MemoryImage(uint8Bytes);
    final completer = Completer<ImageInfo>();
    final stream = provider.resolve(ImageConfiguration());

    void errorListener(dynamic exception, StackTrace stackTrace) {
      completer.complete(null);
      FlutterError.reportError(
        FlutterErrorDetails(
          context: DiagnosticsNode.message('image load failed'),
          library: 'flutter_image_utils',
          exception: exception,
          stack: stackTrace,
          silent: true,
        ),
      );
    }

    final listener = ImageStreamListener(
      (info, _) => completer.complete(info),
      onError: errorListener,
    );

    stream.addListener(listener);
    final info = await completer.future;
    stream.removeListener(listener);

    setState(() {
      _processTime = null;
      _imgBytes = uint8Bytes;
      _processedBytes = uint8Bytes;
      _x = 0;
      _y = 0;
      _sw = info.image.width;
      _sh = info.image.height;
      _dw = _sw;
      _dh = _sh;
      _format = FlutterImageUtils.jpeg;
    });
  }

  Future<void> _crop() async {
    setState(() {
      _processTime = null;
      _isProcessing = true;
    });

    final stopwatch = Stopwatch()..start();
    final cropped = await FlutterImageUtils.cropImage(
      _imgBytes,
      x: _x,
      y: _y,
      width: _dw,
      height: _dh,
      quality: _quality,
      format: _format,
    );

    setState(() {
      _processTime = stopwatch.elapsedMilliseconds;
      _processedBytes = cropped;
      _isProcessing = false;
    });

    stopwatch.stop();
  }

  Future<void> _resizeToMax() async {
    setState(() {
      _processTime = null;
      _isProcessing = true;
    });

    final stopwatch = Stopwatch()..start();
    final resized = await FlutterImageUtils.resizeImageToMax(
      _imgBytes,
      maxSize: 200,
      quality: _quality,
      format: _format,
    );

    setState(() {
      _processTime = stopwatch.elapsedMilliseconds;
      _processedBytes = resized;
      _isProcessing = false;
    });

    stopwatch.stop();
  }

  Future<void> _rotate() async {
    setState(() {
      _processTime = null;
      _isProcessing = true;
    });

    final stopwatch = Stopwatch()..start();
    final rotated = await FlutterImageUtils.rotateImage(
      _imgBytes,
      angle: 60,
      quality: _quality,
      format: _format,
    );

    setState(() {
      _processTime = stopwatch.elapsedMilliseconds;
      _processedBytes = rotated;
      _isProcessing = false;
    });

    stopwatch.stop();
  }

  Widget _buildButton({String text, VoidCallback onPressed}) {
    return FlatButton(
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
      color: Colors.blue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('flutter_image_utils'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: _buildButton(
                          text: 'camera',
                          onPressed: () => _pickImage(ImageSource.camera),
                        ),
                      ),
                      Container(width: 16.0),
                      Expanded(
                        child: _buildButton(
                          text: 'photo lib',
                          onPressed: () => _pickImage(ImageSource.gallery),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 32.0, bottom: 8.0),
                    child: Text(
                      'cropping options:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text('x: $_x'),
                        flex: 1,
                      ),
                      Expanded(
                        child: Slider(
                          value: _x.toDouble(),
                          min: 0,
                          max: _sw.toDouble(),
                          divisions: _sw == 0 ? 1 : _sw,
                          onChanged: (v) => setState(() => _x = v.toInt()),
                        ),
                        flex: 3,
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text('y: $_y'),
                        flex: 1,
                      ),
                      Expanded(
                        child: Slider(
                          value: _y.toDouble(),
                          min: 0,
                          max: _sh.toDouble(),
                          divisions: _sh == 0 ? 1 : _sh,
                          onChanged: (v) => setState(() => _y = v.toInt()),
                        ),
                        flex: 3,
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text('width: $_dw'),
                        flex: 1,
                      ),
                      Expanded(
                        child: Slider(
                          value: _dw.toDouble(),
                          min: 0,
                          max: _sw.toDouble(),
                          divisions: _sw == 0 ? 1 : _sw,
                          onChanged: (v) => setState(() => _dw = v.toInt()),
                        ),
                        flex: 3,
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text('height: $_dh'),
                        flex: 1,
                      ),
                      Expanded(
                        child: Slider(
                          value: _dh.toDouble(),
                          min: 0,
                          max: _sh.toDouble(),
                          divisions: _sh == 0 ? 1 : _sh,
                          onChanged: (v) => setState(() => _dh = v.toInt()),
                        ),
                        flex: 3,
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text('quality: $_quality'),
                        flex: 1,
                      ),
                      Expanded(
                        child: Slider(
                          value: _quality.toDouble(),
                          min: 0,
                          max: 100,
                          divisions: 100 == 0 ? 1 : 100,
                          onChanged: (v) =>
                              setState(() => _quality = v.toInt()),
                        ),
                        flex: 3,
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text('format:'),
                        flex: 1,
                      ),
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Spacer(),
                            Radio(
                              value: FlutterImageUtils.jpeg,
                              groupValue: _format,
                              onChanged: (f) => setState(() => _format = f),
                            ),
                            Text('jpeg'),
                            Spacer(),
                            Radio(
                              value: FlutterImageUtils.png,
                              groupValue: _format,
                              onChanged: (f) => setState(() => _format = f),
                            ),
                            Text('png'),
                            Spacer(),
                          ],
                        ),
                        flex: 3,
                      )
                    ],
                  ),
                  _buildButton(
                    text: 'crop',
                    onPressed: _isProcessing || _imgBytes == null
                        ? null
                        : () => _crop(),
                  ),
                  Container(height: 32.0),
                  _buildButton(
                    text: 'rotate',
                    onPressed: _isProcessing || _imgBytes == null
                        ? null
                        : () => _rotate(),
                  ),
                  _buildButton(
                    text: 'resize to max',
                    onPressed: _isProcessing || _imgBytes == null
                        ? null
                        : () => _resizeToMax(),
                  ),
                  _imgBytes != null
                      ? Container(
                          margin: const EdgeInsets.only(top: 16.0),
                          child: AspectRatio(
                            aspectRatio: _sw / _sh,
                            child: Container(
                              color: Colors.orange,
                              child: Image(
                                image: MemoryImage(_processedBytes),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  _processTime != null
                      ? Container(
                          child: Text('time elapsed: ${_processTime}ms'),
                          margin: const EdgeInsets.only(top: 16.0),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
