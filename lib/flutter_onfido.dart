// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

import 'onfido_config.dart';

export './enums.dart';
export './onfido_config.dart';

typedef OnOnfidoEvent = void Function(
  String name,
  Map<String, dynamic> properties,
);

abstract class FlutterOnfido {
  FlutterOnfido._();

  static const _channel = MethodChannel('flutter_onfido');

  static Future<OnfidoResult> start({
    required OnfidoConfig config,
    OnfidoIOSAppearance iosAppearance = const OnfidoIOSAppearance(),
    OnOnfidoEvent? onEvent,
  }) async {
    final error = _validateConfig(config);
    if (error != null) {
      throw OnfidoConfigValidationException(error);
    }

    if (onEvent != null) {
      _listenToEvents(onEvent);
    }

    return _channel.invokeMethod('start', {
      'config': config.toMap(),
      'appearance': iosAppearance.toMap(),
      'listenToUserEvents': onEvent != null,
    }).then((result) {
      final Map<String, dynamic> jsonResult = jsonDecode(jsonEncode(result));
      return OnfidoResult.fromMap(jsonResult);
    }).whenComplete(() => _stopListeningToEvents());
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

  static void _listenToEvents(OnOnfidoEvent onEvent) {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'event':
          try {
            final Map args = call.arguments;
            final String name = args['name'];
            final properties = Map<String, dynamic>.from(args['properties']);
            onEvent(name, properties);
          } catch (error) {}
          break;
        default:
          break;
      }
    });
  }

  static void _stopListeningToEvents() {
    _channel.setMethodCallHandler(null);
  }
}

class OnfidoConfigValidationException implements Exception {
  OnfidoConfigValidationException(this.message);

  final String message;
}
