// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';
import 'dart:developer';

import 'package:flutter/services.dart';

import 'onfido_config.dart';

export './enums.dart';
export './onfido_config.dart';

abstract class FlutterOnfido {
  FlutterOnfido._();

  static const _channel = MethodChannel('flutter_onfido');

  static Future<OnfidoResult> start({
    required OnfidoConfig config,
    OnfidoIOSAppearance iosAppearance = const OnfidoIOSAppearance(),
  }) async {
    try {
      final error = _validateConfig(config);
      if (error != null) {
        throw OnfidoConfigValidationException(error);
      }
      final confingJson = config.toMap();
      await _channel.invokeMethod('start', {
        'config': confingJson,
        'appearance': iosAppearance.toMap(),
      });

      return OnfidoResult();
      // return OnfidoResult.fromJson(
      // _jsonDecoder.convert(_jsonEncoder.convert(result)));

    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  static String? _validateConfig(OnfidoConfig config) {
    if (config.sdkToken == null || config.sdkToken!.isEmpty) {
      return 'Sdk token is missing';
    }
    if (!RegExp(r'^[A-Za-z0-9-_=]+\.[A-Za-z0-9-_=]+\.?[A-Za-z0-9-_.+/=]*$')
        .hasMatch(config.sdkToken!)) {
      return 'Sdk token is not valid JWT';
    }
    if (config.flowSteps == null) {
      return 'Flow steps configuration is missing';
    }
    if (config.flowSteps!.captureDocument == null &&
        config.flowSteps!.captureFace == null) {
      return "Flow steps doesn't include either captureDocument options or captureFace options";
    }
    return null;
  }
}

class OnfidoConfigValidationException implements Exception {
  OnfidoConfigValidationException(this.message);
  final String message;
}
