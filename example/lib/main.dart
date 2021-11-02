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
          'eyJhbGciOiJFUzUxMiJ9.eyJleHAiOjE2MzU4NTU3MDcsInBheWxvYWQiOnsiYXBwIjoiNDdlNzI2NGEtOTNmNC00YzdhLWFiMGUtZDc2M2YzZGIzNTY4IiwiY2xpZW50X3V1aWQiOiI2NWQ3NTQ1YS0zYzc5LTQxYjItOTE0YS0xMmUzMWQ4ZThlMGIiLCJpc19zYW5kYm94Ijp0cnVlLCJzYXJkaW5lX3Nlc3Npb24iOiJkODc4MDIwNS1iOWIwLTRkZDgtYWRiNy0wMWVmZWIxZTJkMTAifSwidXVpZCI6ImdiMU80UUwzYWlfIiwidXJscyI6eyJ0ZWxlcGhvbnlfdXJsIjoiaHR0cHM6Ly90ZWxlcGhvbnkudXMub25maWRvLmNvbSIsImRldGVjdF9kb2N1bWVudF91cmwiOiJodHRwczovL3Nkay51cy5vbmZpZG8uY29tIiwic3luY191cmwiOiJodHRwczovL3N5bmMub25maWRvLmNvbSIsImhvc3RlZF9zZGtfdXJsIjoiaHR0cHM6Ly9pZC5vbmZpZG8uY29tIiwiYXV0aF91cmwiOiJodHRwczovL2FwaS51cy5vbmZpZG8uY29tIiwib25maWRvX2FwaV91cmwiOiJodHRwczovL2FwaS51cy5vbmZpZG8uY29tIn19.MIGHAkFOCdRoQyVlUA6idnflBzaC6zJe7g1x2s66CzuctdnVEP22eKw_FvIlQtcw8bA8RKx3JrqtNOFRF7nxNNgjQ38JygJCAefxjBp3nwf-7OyBku6vkh62pLqGcnPDnvQ8GFeYMRfSt7EHeXF4rCZJJG8VBTFa1NpU92D_FWOLSDKbw21xxrpO';
      // 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c';
      final result = await FlutterOnfido.start(
        config: OnfidoConfig(
          sdkToken:
              // PROVIDE SDK TOKEN YOU'VE GOT FROM YOUR BACKEND
              exampleSdkToken,
          flowSteps: OnfidoFlowSteps(
            welcome: true,
            captureDocument: OnfidoCaptureDocumentStep(
              countryCode: OnfidoCountryCode.BRA,
              docType: OnfidoDocumentType.GENERIC,
            ),
            captureFace: OnfidoCaptureFaceStep(OnfidoCaptureType.VIDEO),
          ),
        ),
        iosAppearance: const OnfidoIOSAppearance(
          onfidoPrimaryColor: '#0043DF',
        ),
      );
      log(result.toString());
      // ASK YOUR BACKEND IF USER HAS PASSED VERIFICATION
    } catch (error) {
      if(error is PlatformException){
        if(error.code == 'cancel'){
      
        }
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
