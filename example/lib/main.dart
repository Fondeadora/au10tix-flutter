import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:au10tix_flutter/au10tix_flutter.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _controller = TextEditingController();
  final _loadLocally = true;
  final _load2 = false;
  final _load3 = false;

  Au10tixResponse _response = Au10tixResponse(DocumentType.none, '', '', '');

  final _fakeToken =
      "eyJraWQiOiI2Q2NWRThxRTgzUThEU0s5V21IQllCZTQ4UmdqZmpHX3JlSGpjS08xb3JRIiwiYWxnIjoiUlMyNTYifQ.eyJ2ZXIiOjEsImp0aSI6IkFULmF5UkV6dFg4NC1PdkRncDB4c0pqRWZMUTFTTk1vSHU2aE15YXhEczE0R2MiLCJpc3MiOiJodHRwczovL2xvZ2luLmF1MTB0aXguY29tL29hdXRoMi9hdXMzbWx0czVzYmU5V0Q4VjM1NyIsImF1ZCI6ImF1MTB0aXgiLCJpYXQiOjE2MTMwNzQ0MzMsImV4cCI6MTYxMzA3NTAzMywiY2lkIjoiMG9hNDlydzRiaFJsR2I3bFozNTciLCJzY3AiOlsic2RjIiwicGZsIiwibW9iaWxlc2RrIl0sInN1YiI6IjBvYTQ5cnc0YmhSbEdiN2xaMzU3IiwiYXBpVXJsIjoiaHR0cHM6Ly9ldXMtYXBpLmF1MTB0aXhzZXJ2aWNlc3N0YWdpbmcuY29tIiwiYm9zVXJsIjoiaHR0cHM6Ly9ib3MtZXVzLXdlYi5hdTEwdGl4c2VydmljZXNzdGFnaW5nLmNvbSIsImNsaWVudE9yZ2FuaXphdGlvbk5hbWUiOiJGb25kZWFkb3JhIiwiY2xpZW50T3JnYW5pemF0aW9uSWQiOjM2MX0.AgNct0dZf1gHlR0guLn4DpeRKCeII8jyRZGwa4-6QgZKvlbuhPekGtPvgP-2FAeXQL3HMof6beER5YncVSy_hqFl7V8tvp-BIpliKqpsJ9wuyPmBJN0DNXmNw8z_H3K62HVtyFrBqhE1-rKWkR3tNEYs-K8L6AOZfuSYAczX9cHI1giPjWXVUBazxYKOrxrqIpAS2DDvxyZO8UKtERom49_rSxdLpF6EkFvxmTjHevw1wem6_2xVVMmJVmZbVB6QAa6aQNigFFaBVqrTwfWN-DCiroV1tanzHKd5I9Wn3nuxFwKThRWBeygzZhm1XTkoh4gzpNh7Dd06bYRxpO-W1A";

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller.text = _fakeToken;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin Au10tix'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _controller,
                  decoration: InputDecoration(labelText: 'JWT'),
                ),
                FlatButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.black,
                  padding: EdgeInsets.all(8.0),
                  splashColor: Colors.blueAccent,
                  onPressed: () async {
                    Au10tixResponse res =
                        await Au10tixFlutter.verifyId(_controller.text);
                    setState(() {
                      _response = res;
                    });
                  },
                  child: Text(
                    "Iniciar Au10tix",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                if (_loadLocally) ...[
                  _getImageContainer(_response.documentFrontPath),
                  SizedBox(
                    height: 10,
                  ),
                  Text(_response.documentFrontPath),
                  SizedBox(
                    height: 10,
                  ),
                  Text(_response.documentBackPath),
                  SizedBox(
                    height: 10,
                  ),
                  //_getImageContainer(_response.documentBackPath),
                  _getImageContainer(_response.selfiePath),
                ] else ...[
                  _getImageData(_response.documentFrontPath),
                  _getImageData(_response.documentBackPath),
                  _getImageData(_response.selfiePath),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getImageData(String _base64) {
    if (_base64.isEmpty) return Container();

    return Card(
      child: Container(
        child: Image.memory(
          base64Decode(_base64),
          height: 280,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _getImageContainer(String urlFile) {
    return urlFile.isNotEmpty
        ? Card(
            child: Container(
              child: Image.file(
                new File(urlFile),
                height: 280,
                fit: BoxFit.cover,
              ),
            ),
          )
        : SizedBox();
  }
}
