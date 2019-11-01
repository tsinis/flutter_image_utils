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
  Uint8List _croppedBytes;
  int _x = 0;
  int _y = 0;
  int _dw = 0;
  int _dh = 0;
  int _sw = 0;
  int _sh = 0;
  int _quality = 100;

  bool _isCropping = false;
  int _cropTime;

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

    void listener(ImageInfo info, bool syncCall) => completer.complete(info);

    void errorListener(dynamic exception, StackTrace stackTrace) {
      completer.complete(null);
      FlutterError.reportError(new FlutterErrorDetails(
        context: 'image load failed ',
        library: 'flutter_image_utils',
        exception: exception,
        stack: stackTrace,
        silent: true,
      ));
    }

    stream.addListener(listener, onError: errorListener);
    final info = await completer.future;
    stream.removeListener(listener);

    setState(() {
      _cropTime = null;
      _imgBytes = uint8Bytes;
      _croppedBytes = uint8Bytes;
      _x = 0;
      _y = 0;
      _sw = info.image.width;
      _sh = info.image.height;
      _dw = _sw;
      _dh = _sh;
    });
  }

  Future<void> _crop() async {
    setState(() {
      _cropTime = null;
      _isCropping = true;
    });

    final stopwatch = Stopwatch()..start();
    final cropped = await FlutterImageUtils.cropImage(
      _imgBytes,
      x: _x,
      y: _y,
      width: _dw,
      height: _dh,
      quality: _quality,
    );

    setState(() {
      _cropTime = stopwatch.elapsedMilliseconds;
      _croppedBytes = cropped;
      _isCropping = false;
    });

    stopwatch.stop();
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
                        child: FlatButton(
                          child: Text(
                            'camera',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          onPressed: () => _pickImage(ImageSource.camera),
                        ),
                      ),
                      Container(width: 16.0),
                      Expanded(
                        child: FlatButton(
                          child: Text(
                            'photo lib',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          onPressed: () => _pickImage(ImageSource.gallery),
                        ),
                      ),
                    ],
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
                          onChanged: (v) => setState(() => _quality = v.toInt()),
                        ),
                        flex: 3,
                      )
                    ],
                  ),
                  FlatButton(
                    child: Text(
                      'crop',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.blue,
                    disabledColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    onPressed: _isCropping || _imgBytes == null ? null : () => _crop(),
                  ),
                  _imgBytes != null
                      ? Container(
                          margin: const EdgeInsets.only(top: 16.0),
                          child: AspectRatio(
                            aspectRatio: _sw / _sh,
                            child: Container(
                              color: Colors.orange,
                              child: Image(
                                image: MemoryImage(_croppedBytes),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  _cropTime != null
                      ? Container(
                          child: Text('time elapsed: ${_cropTime}ms'),
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
