import 'dart:convert';

import 'enums.dart';

class OnfidoConfig {
  const OnfidoConfig({
    required this.sdkToken,
    required this.flowSteps,
    this.locale,
    this.localizationTable,
  });

  factory OnfidoConfig.fromMap(Map<String, dynamic> map) {
    return OnfidoConfig(
      sdkToken: map['sdkToken'],
      flowSteps: OnfidoFlowSteps.fromMap(map['flowSteps']),
      locale: map['locale'],
    );
  }

  final String? sdkToken;
  final OnfidoFlowSteps? flowSteps;

  /// Must be in xx or xx_YY formats.
  final String? locale;

  /// For iOS only.
  ///
  /// This will determine which localization table prefix the sdk will try to
  /// get the custom [locale] localizations from.
  /// Default is `Onfido_` which will result in `Onfido_${locale}.strings` file.
  final String? localizationTable;

  Map<String, dynamic> toMap() {
    return {
      'sdkToken': sdkToken,
      'flowSteps': flowSteps?.toMap(),
      'locale': locale,
      'localizationTable': localizationTable,
    };
  }
}

class OnfidoFlowSteps {
  OnfidoFlowSteps({
    this.welcome,
    this.captureDocument,
    this.captureFace,
  });

  factory OnfidoFlowSteps.fromMap(Map<String, dynamic> map) {
    return OnfidoFlowSteps(
      welcome: map['welcome'],
      captureDocument:
          OnfidoCaptureDocumentStep.fromMap(map['captureDocument']),
      captureFace: OnfidoCaptureFaceStep.fromMap(map['captureFace']),
    );
  }

  final bool? welcome;
  final OnfidoCaptureDocumentStep? captureDocument;
  final OnfidoCaptureFaceStep? captureFace;

  Map<String, dynamic> toMap() {
    return {
      'welcome': welcome,
      'captureDocument': captureDocument?.toMap(),
      'captureFace': captureFace?.toMap(),
    };
  }
}

class OnfidoCaptureDocumentStep {
  OnfidoCaptureDocumentStep({
    required this.docType,
    required this.countryCode,
  });

  factory OnfidoCaptureDocumentStep.fromMap(Map<String, dynamic> map) {
    return OnfidoCaptureDocumentStep(
      docType: enumFromString(
        key: map['docType'],
        values: OnfidoDocumentType.values,
        orElse: OnfidoDocumentType.UNKNOWN,
      ),
      countryCode: enumFromString(
        key: map['countryCode'],
        values: OnfidoCountryCode.values,
        orElse: OnfidoCountryCode.UNKNOWN,
      ),
    );
  }

  final OnfidoDocumentType? docType;
  final OnfidoCountryCode? countryCode;

  Map<String, dynamic> toMap() {
    return {
      if (docType != null) 'docType': enumToString(docType!),
      if (countryCode != null) 'countryCode': enumToString(countryCode!),
    };
  }
}

class OnfidoCaptureFaceStep {
  OnfidoCaptureFaceStep(this.type);

  factory OnfidoCaptureFaceStep.fromMap(Map<String, dynamic> map) {
    return OnfidoCaptureFaceStep(
      enumFromString(
        key: map['type'],
        values: OnfidoCaptureType.values,
        orElse: OnfidoCaptureType.UNKNOWN,
      ),
    );
  }

  final OnfidoCaptureType? type;

  Map<String, dynamic> toMap() {
    return {
      'type': type != null ? enumToString(type!) : null,
    };
  }
}

class OnfidoIOSAppearance {
  const OnfidoIOSAppearance({
    this.onfidoPrimaryButtonTextColor,
    this.onfidoPrimaryButtonColorPressed,
    this.onfidoIosSupportDarkMode = false,
    this.onfidoPrimaryColor,
  });

  factory OnfidoIOSAppearance.fromMap(Map<String, dynamic> map) {
    return OnfidoIOSAppearance(
      onfidoPrimaryColor: map['onfidoPrimaryColor'],
      onfidoPrimaryButtonTextColor: map['onfidoPrimaryButtonTextColor'],
      onfidoPrimaryButtonColorPressed: map['onfidoPrimaryButtonColorPressed'],
      onfidoIosSupportDarkMode: map['onfidoIosSupportDarkMode'],
    );
  }

  final String? onfidoPrimaryColor;
  final String? onfidoPrimaryButtonTextColor;
  final String? onfidoPrimaryButtonColorPressed;
  final bool? onfidoIosSupportDarkMode;

  Map<String, dynamic> toMap() {
    return {
      'onfidoPrimaryColor': onfidoPrimaryColor,
      'onfidoPrimaryButtonTextColor': onfidoPrimaryButtonTextColor,
      'onfidoPrimaryButtonColorPressed': onfidoPrimaryButtonColorPressed,
      'onfidoIosSupportDarkMode': onfidoIosSupportDarkMode,
    };
  }
}

class OnfidoResult {
  OnfidoResult({
    this.document,
    this.face,
  });

  final OnfidoDocumentResult? document;
  final OnfidoFaceResult? face;

  Map<String, dynamic> toMap() {
    return {
      'document': document?.toMap(),
      'face': face?.toMap(),
    };
  }

  factory OnfidoResult.fromMap(Map<String, dynamic> map) {
    return OnfidoResult(
      document: map['document'] != null
          ? OnfidoDocumentResult.fromMap(map['document'])
          : null,
      face: map['face'] != null ? OnfidoFaceResult.fromMap(map['face']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory OnfidoResult.fromJson(String source) =>
      OnfidoResult.fromMap(json.decode(source));
}

class OnfidoFaceResult {
  OnfidoFaceResult({this.id, this.variant});

  factory OnfidoFaceResult.fromMap(Map<String, dynamic> map) {
    return OnfidoFaceResult(
      id: map['id'],
      variant: enumFromString<OnfidoCaptureType>(
        key: map['variant'] as String,
        values: OnfidoCaptureType.values,
        orElse: OnfidoCaptureType.UNKNOWN,
      ),
    );
  }

  final String? id;
  final OnfidoCaptureType? variant;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'variant': variant != null ? enumToString(variant!) : null,
    };
  }

  @override
  String toString() => 'OnfidoFaceResult(id: $id, variant: $variant)';
}

class OnfidoDocumentResult {
  OnfidoDocumentResult({this.front, this.back});

  final OnfidoDocumentResultDetail? front;
  final OnfidoDocumentResultDetail? back;

  Map<String, dynamic> toMap() {
    return {
      'front': front?.toMap(),
      'back': back?.toMap(),
    };
  }

  factory OnfidoDocumentResult.fromMap(Map<String, dynamic> map) {
    return OnfidoDocumentResult(
      front: map['front'] != null
          ? OnfidoDocumentResultDetail.fromMap(map['front'])
          : null,
      back: map['back'] != null
          ? OnfidoDocumentResultDetail.fromMap(map['back'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory OnfidoDocumentResult.fromJson(String source) =>
      OnfidoDocumentResult.fromMap(json.decode(source));
}

class OnfidoDocumentResultDetail {
  OnfidoDocumentResultDetail(this.id);

  final String? id;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
    };
  }

  factory OnfidoDocumentResultDetail.fromMap(Map<String, dynamic> map) {
    return OnfidoDocumentResultDetail(
      map['id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OnfidoDocumentResultDetail.fromJson(String source) =>
      OnfidoDocumentResultDetail.fromMap(json.decode(source));
}

T enumFromString<T>({
  required String? key,
  required List<T> values,
  required T orElse,
}) =>
    values.firstWhere(
        (v) => key?.toLowerCase() == enumToString(v!).toLowerCase(),
        orElse: () => orElse);

String enumToString(Object o) => o.toString().split('.').last;
