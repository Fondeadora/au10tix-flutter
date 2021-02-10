import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:au10tix_flutter/au10tix_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _controller = TextEditingController();
  Au10tixResponse _response;

  final _fakeToken =
      "eyJraWQiOiI2Q2NWRThxRTgzUThEU0s5V21IQllCZTQ4UmdqZmpHX3JlSGpjS08xb3JRIiwiYWxnIjoiUlMyNTYifQ.eyJ2ZXIiOjEsImp0aSI6IkFULlZHc3VvT0tnMFdXejcyNDg0Y2pIMEpBV242WkZyNHdOUEpoNVRDOVFBU2ciLCJpc3MiOiJodHRwczovL2xvZ2luLmF1MTB0aXguY29tL29hdXRoMi9hdXMzbWx0czVzYmU5V0Q4VjM1NyIsImF1ZCI6ImF1MTB0aXgiLCJpYXQiOjE2MTI5MDAxMTcsImV4cCI6MTYxMjkwMDcxNywiY2lkIjoiMG9hNDlydzRiaFJsR2I3bFozNTciLCJzY3AiOlsic2RjIiwicGZsIiwibW9iaWxlc2RrIl0sInN1YiI6IjBvYTQ5cnc0YmhSbEdiN2xaMzU3IiwiYXBpVXJsIjoiaHR0cHM6Ly9ldXMtYXBpLmF1MTB0aXhzZXJ2aWNlc3N0YWdpbmcuY29tIiwiYm9zVXJsIjoiaHR0cHM6Ly9ib3MtZXVzLXdlYi5hdTEwdGl4c2VydmljZXNzdGFnaW5nLmNvbSIsImNsaWVudE9yZ2FuaXphdGlvbk5hbWUiOiJGb25kZWFkb3JhIiwiY2xpZW50T3JnYW5pemF0aW9uSWQiOjM2MX0.X8TN5mQMgTh7WCZoarX8arlqXlF96GfLh9Mbz2sZyD8-twyoglBut54pSFIPcohGFDvRhcSXGlTwlwrD-4fGfgnbKZaXKVV9OPPs86V-YUPesX-i1nn0_Em302uQfKcKuPCxMui_ZYubtisrPAfJcprmOPA34k7_jS3sIOBYjs6bOWbwy3r4nTQTuVd8z31kxWcr_UGOI4diCpFmW4AKTDKpICYaWu8IQttzznf4MMf2T7cHPXi9P0IZ484mT3qLB8rVQyUOibH4MCleMvPbe4KRXt5CPyaEFzxl8vrt6EM28-a5khndQg2buhdlpNx8IbGtiT7Q8HEfUd68fpr-hQ";

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin Au10tix'),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
          child: Column(
            children: [
              Visibility(
                visible: _response == null,
                child: Column(
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
                      //onPressed: () =>
                      //    {Au10tixFlutter.verifyId(_controller.text)},
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
                    )
                  ],
                ),
              ),
              Visibility(
                visible:
                    _response != null && _response.type != DocumentType.none,
                child: Container(
                  height: 100,
                  width: 200,
                  color: Colors.blue,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
