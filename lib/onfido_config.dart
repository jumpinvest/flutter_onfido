import 'enums.dart';

part 'onfido_config.g.dart'; // GENERATED BY json_serializable, dependency removed, if any changes use online generator

class OnfidoConfig {
  final String? sdkToken;
  final OnfidoFlowSteps? flowSteps;
  final String? locale;

  const OnfidoConfig({
    required this.sdkToken,
    required this.flowSteps,
    this.locale
  });

  factory OnfidoConfig.fromJson(Map<String, dynamic> json) =>
      _$OnfidoConfigFromJson(json);
  Map<String, dynamic> toJson() => _$OnfidoConfigToJson(this);
}

class OnfidoFlowSteps {
  final bool? welcome;
  final OnfidoCaptureDocumentStep? captureDocument;
  final OnfidoCaptureFaceStep? captureFace;

  OnfidoFlowSteps({
    this.welcome,
    this.captureDocument,
    this.captureFace,
  });

  factory OnfidoFlowSteps.fromJson(Map<String, dynamic> json) =>
      _$OnfidoFlowStepsFromJson(json);
  Map<String, dynamic> toJson() => _$OnfidoFlowStepsToJson(this);
}

class OnfidoCaptureDocumentStep {
  final OnfidoDocumentType? docType;
  final OnfidoCountryCode? countryCode;

  OnfidoCaptureDocumentStep({
    required this.docType,
    required this.countryCode,
  });

  factory OnfidoCaptureDocumentStep.fromJson(Map<String, dynamic> json) =>
      _$OnfidoCaptureDocumentStepFromJson(json);
  Map<String, dynamic> toJson() => _$OnfidoCaptureDocumentStepToJson(this);
}

class OnfidoCaptureFaceStep {
  final OnfidoCaptureType? type;

  OnfidoCaptureFaceStep(this.type);

  factory OnfidoCaptureFaceStep.fromJson(Map<String, dynamic> json) =>
      _$OnfidoCaptureFaceStepFromJson(json);
  Map<String, dynamic> toJson() => _$OnfidoCaptureFaceStepToJson(this);
}

class OnfidoIOSAppearance {
  final String? onfidoPrimaryColor;
  final String? onfidoPrimaryButtonTextColor;
  final String? onfidoPrimaryButtonColorPressed;
  final bool? onfidoIosSupportDarkMode;

  const OnfidoIOSAppearance({
    this.onfidoPrimaryButtonTextColor,
    this.onfidoPrimaryButtonColorPressed,
    this.onfidoIosSupportDarkMode = false,
    this.onfidoPrimaryColor,
  });

  factory OnfidoIOSAppearance.fromJson(Map<String, dynamic> json) =>
      _$OnfidoIOSAppearanceFromJson(json);
  Map<String, dynamic> toJson() => _$OnfidoIOSAppearanceToJson(this);
}

class OnfidoResult {
  final OnfidoDocumentResult? document;
  final OnfidoFaceResult? face;

  OnfidoResult({
    this.document,
    this.face,
  });

  factory OnfidoResult.fromJson(Map<String, dynamic> json) =>
      _$OnfidoResultFromJson(json);
  Map<String, dynamic> toJson() => _$OnfidoResultToJson(this);
}

class OnfidoFaceResult {
  final String? id;
  final OnfidoCaptureType? variant;

  OnfidoFaceResult({this.id, this.variant});

  factory OnfidoFaceResult.fromJson(Map<String, dynamic> json) =>
      _$OnfidoFaceResultFromJson(json);
  Map<String, dynamic> toJson() => _$OnfidoFaceResultToJson(this);
}

class OnfidoDocumentResult {
  final OnfidoDocumentResultDetail? front;
  final OnfidoDocumentResultDetail? back;

  OnfidoDocumentResult({this.front, this.back});

  factory OnfidoDocumentResult.fromJson(Map<String, dynamic> json) =>
      _$OnfidoDocumentResultFromJson(json);
  Map<String, dynamic> toJson() => _$OnfidoDocumentResultToJson(this);
}

class OnfidoDocumentResultDetail {
  final String? id;

  OnfidoDocumentResultDetail(this.id);

  factory OnfidoDocumentResultDetail.fromJson(Map<String, dynamic> json) =>
      _$OnfidoDocumentResultDetailFromJson(json);
  Map<String, dynamic> toJson() => _$OnfidoDocumentResultDetailToJson(this);
}
