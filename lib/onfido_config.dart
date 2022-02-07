import 'enums.dart';

class OnfidoConfig {
  const OnfidoConfig({
    required this.sdkToken,
    required this.flowSteps,
  });

  factory OnfidoConfig.fromMap(Map<String, dynamic> map) {
    return OnfidoConfig(
      sdkToken: map['sdkToken'],
      flowSteps: OnfidoFlowSteps.fromMap(map['flowSteps']),
    );
  }

  final String? sdkToken;
  final OnfidoFlowSteps? flowSteps;

  Map<String, dynamic> toMap() {
    return {
      'sdkToken': sdkToken,
      'flowSteps': flowSteps?.toMap(),
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
    if(docType != null && countryCode != null){
      return {
        'docType': docType != null ? enumToString(docType!) : null,
        'countryCode': countryCode != null ? enumToString(countryCode!) : null,
      };
    }
    return {};
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

  factory OnfidoResult.fromMap(Map<String, dynamic> map) {
    return OnfidoResult(
      document: OnfidoDocumentResult.fromMap(
          Map<String, dynamic>.from(map['document'])),
      face: OnfidoFaceResult.fromMap(Map<String, dynamic>.from(map['face'])),
    );
  }

  final OnfidoDocumentResult? document;
  final OnfidoFaceResult? face;

  Map<String, dynamic> toMap() {
    return {
      'document': document?.toMap(),
      'face': face?.toMap(),
    };
  }

  @override
  String toString() => 'OnfidoResult(document: $document, face: $face)';
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

  factory OnfidoDocumentResult.fromMap(Map<String, dynamic> map) {
    return OnfidoDocumentResult(
      front: OnfidoDocumentResultDetail.fromMap(
          Map<String, dynamic>.from(map['front'])),
      back: OnfidoDocumentResultDetail.fromMap(
          Map<String, dynamic>.from(map['back'])),
    );
  }

  final OnfidoDocumentResultDetail? front;
  final OnfidoDocumentResultDetail? back;

  Map<String, dynamic> toMap() {
    return {
      'front': front?.toMap(),
      'back': back?.toMap(),
    };
  }

  @override
  String toString() => 'OnfidoDocumentResult(front: $front, back: $back)';
}

class OnfidoDocumentResultDetail {
  OnfidoDocumentResultDetail(this.id);
  factory OnfidoDocumentResultDetail.fromMap(Map<String, dynamic> map) {
    return OnfidoDocumentResultDetail(
      map['id'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
    };
  }

  final String? id;

  @override
  String toString() => 'OnfidoDocumentResultDetail(id: $id)';
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
