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

  Au10tixResponse _response;

  final _fakeToken =
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6IkZST1kgVEVTVCJ9.eyJzdWIiOiIwb2E0OXJ3NGJoUmxHYjdsWjM1NyIsImlzcyI6IjBvYTQ5cnc0YmhSbEdiN2xaMzU3IiwiYXVkIjoiaHR0cHM6Ly9sb2dpbi5hdTEwdGl4LmNvbS9vYXV0aDIvYXVzM21sdHM1c2JlOVdEOFYzNTcvdjEvdG9rZW4iLCJleHAiOjE2MTQxMTIxMzIuNTAxNTc3Nn0.iKvS51wnRUXI5or2o9BlKd66iMTRwYmItLodilF7Sx-3_IUNzEVom10tSLlcQziTveD_1qYkaH4Tj10iBodiYUQ87_NkXXR7MazD4hbBGUbAqlCVHWGY5bVSZpTSA5d6az91Sxm6ql8yWjlnmnSH9aGIB-TN14Dj64FJEygdRFBoLmQ4uAIg_sgFXLzWGWRckMVGk22XsqRp0TNbKtgj0N4Xte48_SUJhMVAS1vrEVieN_f2FVlibzKryZimrmw_IdvBwi-IC7nIDZUKOJoD84c10T4lXfhLuaNJikxcjQbrKDHOthqt4Lz4M8pP-BKxyPfvf6aSCBouNgvsKPDEDQ";

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
                    Au10tixResponse res = await Au10tixFlutter.verifyId(
                        _controller.text, true, "ine");
                    setState(() {
                      _response = res;
                    });
                  },
                  child: Text(
                    "Iniciar Au10tix",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
