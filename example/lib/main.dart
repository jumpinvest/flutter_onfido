// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_onfido/flutter_onfido.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> init() async {
    try {
      // const exampleSdkToken =
      //     "sdk_sandbox_us.KnnlEbnTf1o.LzRSAHlbKV0hUNc7a4Owtd_JsPnqX6wj";

      const exampleSdkToken =
          'KnnlEbnTf1o.LzRSAHlbKV0hUNc7a4Owtd_JsPnqX6wj';
      // 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c';
      final result = await FlutterOnfido.start(
        config: OnfidoConfig(
          sdkToken:
              // PROVIDE SDK TOKEN YOU'VE GOT FROM YOUR BACKEND
              exampleSdkToken,
          flowSteps: OnfidoFlowSteps(
            welcome: true,
            captureDocument: OnfidoCaptureDocumentStep(
              countryCode: OnfidoCountryCode.USA,
              docType: OnfidoDocumentType.GENERIC,
            ),
            captureFace: OnfidoCaptureFaceStep(OnfidoCaptureType.PHOTO),
          ),
        ),
        iosAppearance: const OnfidoIOSAppearance(
          onfidoPrimaryColor: '#0043DF',
        ),
      );
      log(result.toString());
      // ASK YOUR BACKEND IF USER HAS PASSED VERIFICATION
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              MaterialButton(
                onPressed: init,
                child: const Text('start'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
