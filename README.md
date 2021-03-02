[![Pub](https://img.shields.io/pub/v/au10tix_flutter)](https://pub.dev/packages/au10tix_flutter)

# au10tix_flutter

An Au10tix extension plugin using native SDK
  
# Au10tix Native SDK for Dart
Unofficial Au10tix SDK written in Dart for [Dart](https://www.dartlang.org/).

# Usage

```dart

import 'package:au10tix_flutter/au10tix_flutter.dart';

class _MyAppState extends State<MyApp> {
  Au10tixResponse _response = Au10tixResponse(DocumentType.none, '', '', '');

  // Get token from Au10tix
  final _fakeToken = "eyJraWQiOiI2Q2NWRThx...";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin Au10tix'),
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
            child: FlatButton(
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
                            // Get url document front
                            print("_response.documentFrontPath:: $_response.documentFrontPath");
                            // Get url document back
                            print("_response.documentBackPath:: $_response.documentBackPath");
                            // Get url selfie
                            print("_response.selfiePath:: $_response.selfiePath");
                        });
                    },
                    child: Text(
                        "Iniciar Au10tix",
                        style: TextStyle(fontSize: 20.0),
                    ),
                ),
            ),
        ),
    );
  }

```