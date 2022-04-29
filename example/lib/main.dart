// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          'eyJhbGciOiJFUzUxMiJ9.eyJleHAiOjE2NDQ0MjAwNTIsInBheWxvYWQiOnsiYXBwIjoiYzE1ZDI0MzUtZmJlMy00MDQzLWE4NWMtOGMzMmQ4OTA0MmZjIiwiY2xpZW50X3V1aWQiOiI2NWQ3NTQ1YS0zYzc5LTQxYjItOTE0YS0xMmUzMWQ4ZThlMGIiLCJhcHBsaWNhdGlvbl9pZCI6ImNvbS5mbHVlbmN5YmFuay5mbHV0dGVyX29uZmlkb19leGFtcGxlIiwiaXNfc2FuZGJveCI6dHJ1ZSwic2FyZGluZV9zZXNzaW9uIjoiNjI0ZmVlMTctYjgzNC00MjIxLWE5NDUtNmEwNzU5MWFmNTgxIn0sInV1aWQiOiJ1cmFwSU5JNWpOOCIsInVybHMiOnsidGVsZXBob255X3VybCI6Imh0dHBzOi8vdGVsZXBob255LnVzLm9uZmlkby5jb20iLCJkZXRlY3RfZG9jdW1lbnRfdXJsIjoiaHR0cHM6Ly9zZGsudXMub25maWRvLmNvbSIsInN5bmNfdXJsIjoiaHR0cHM6Ly9zeW5jLm9uZmlkby5jb20iLCJob3N0ZWRfc2RrX3VybCI6Imh0dHBzOi8vaWQub25maWRvLmNvbSIsImF1dGhfdXJsIjoiaHR0cHM6Ly9hcGkudXMub25maWRvLmNvbSIsIm9uZmlkb19hcGlfdXJsIjoiaHR0cHM6Ly9hcGkudXMub25maWRvLmNvbSJ9fQ.MIGHAkFH7Tnx0gZUe2sUL0QzJbXRANwN3ced9f3LrFFNXpLatkXNux5CVaqI-cQ3OWbL6ttLmHrRQetlRM3nHwi6eyJ0IAJCAKm2dBCXaPl7SHSP9ArzvYQExH0K6F_zsZytozTT44RnndGXmaAOhtU3e8MeJ3JRP-JHa9nnhRj7JBC3C1SSQE1C';
      final result = await FlutterOnfido.start(
        config: OnfidoConfig(
          sdkToken:
              // PROVIDE SDK TOKEN YOU'VE GOT FROM YOUR BACKEND
              exampleSdkToken,
          flowSteps: OnfidoFlowSteps(
            welcome: true,
            captureDocument: OnfidoCaptureDocumentStep(
              countryCode: null,
              docType: null,
            ),
            captureFace: OnfidoCaptureFaceStep(OnfidoCaptureType.PHOTO),
          ),
        ),
        onEvent: (
          String name,
          Map<String, dynamic> properties,
        ) {
          log('onEvent: $name $properties');
        },
        iosAppearance: const OnfidoIOSAppearance(
          onfidoPrimaryColor: '#0043DF',
        ),
      );
      log(result.toString());
      // ASK YOUR BACKEND IF USER HAS PASSED VERIFICATION
    } catch (error) {
      log(error.toString());
      if (error is PlatformException) {
        if (error.code == 'cancel') {}
      }
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
