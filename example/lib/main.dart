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
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6IkZST1kgVEVTVCJ9.eyJzdWIiOiIwb2E0OXJ3NGJoUmxHYjdsWjM1NyIsImlzcyI6IjBvYTQ5cnc0YmhSbEdiN2xaMzU3IiwiYXVkIjoiaHR0cHM6Ly9sb2dpbi5hdTEwdGl4LmNvbS9vYXV0aDIvYXVzM21sdHM1c2JlOVdEOFYzNTcvdjEvdG9rZW4iLCJleHAiOjE2MTQwNDE2MTkuNzU1NzIyM30.bYW95mSGXm7ToydF-Yu5mXIwcmRnrauo-NkU8LZGNcwL_EDN0N-3VDBSsZZWfKs85lom4oXtSUkydLi8N1BHKjaaFPPPepjlQFQyX3ytvI8EjrHL2OsqkQmiAtDsy9362vk0W9Gb3QHFghZIesrr2uxjcLEigrJbTEF-7pqKf2nGojJgskJ7gJERjOY-ATQmoneMaUtFW70bvQmxMUCNTGEbirUGmpPkkfIyZRlTdDa1rFlNbKa2LIHAGNPbLc64B98_AkD3pFKt-ipTfZuZ_oDUyNhlS1zZpL19Xpegk5VL2u0Z5E1YMWrVTpzNIC2AjYXjnFrxgsLF4NvDT0M-sQ";

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
