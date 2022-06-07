import Foundation
import Onfido

public class AppearancePublic: NSObject {

    public let primaryColor: UIColor
    public let primaryTitleColor: UIColor
    public let primaryBackgroundPressedColor: UIColor
    public let supportDarkMode: Bool

    public init(
        primaryColor: UIColor,
        primaryTitleColor: UIColor,
        primaryBackgroundPressedColor: UIColor,
        supportDarkMode: Bool = true) {
        self.primaryColor = primaryColor
        self.primaryTitleColor = primaryTitleColor
        self.primaryBackgroundPressedColor = primaryBackgroundPressedColor
        self.supportDarkMode = supportDarkMode
    }
}

public func loadAppearance(config: NSDictionary) throws -> AppearancePublic? {

    if let jsonResult = config as? Dictionary<String, AnyObject> {
        let primaryColor: UIColor = (jsonResult["onfidoPrimaryColor"] is NSNull)
                ? UIColor.primaryColor : UIColor.from(hex: jsonResult["onfidoPrimaryColor"] as! String)
        let primaryTitleColor: UIColor = (jsonResult["onfidoPrimaryButtonTextColor"] is NSNull)
                ? UIColor.white : UIColor.from(hex: jsonResult["onfidoPrimaryButtonTextColor"] as! String)
        let primaryBackgroundPressedColor: UIColor = (jsonResult["onfidoPrimaryButtonColorPressed"] is NSNull)
                ? UIColor.primaryButtonColorPressed : UIColor.from(hex: jsonResult["onfidoPrimaryButtonColorPressed"] as! String)
        let supportDarkMode: Bool = (jsonResult["onfidoIosSupportDarkMode"] is NSNull)
                ? true : jsonResult["onfidoIosSupportDarkMode"] as! Bool

        let appearancePublic = AppearancePublic(
                primaryColor: primaryColor,
                primaryTitleColor: primaryTitleColor,
                primaryBackgroundPressedColor: primaryBackgroundPressedColor,
                supportDarkMode: supportDarkMode
        )
        return appearancePublic
    } else {
        return nil
    }
}

public func loadAppearanceFromConfig(config: NSDictionary) throws -> Appearance {
    let appearancePublic = try loadAppearance(config: config)

    if let appearancePublic = appearancePublic {
        let apperance = Appearance();
        apperance.primaryColor = appearancePublic.primaryColor;
        apperance.primaryTitleColor = appearancePublic.primaryTitleColor;
        apperance.primaryBackgroundPressedColor = appearancePublic.primaryBackgroundPressedColor;
        apperance.supportDarkMode = appearancePublic.supportDarkMode;
        return apperance;
    } else {
        let apperance = Appearance.default;
        apperance.primaryColor = UIColor.primaryColor;
        apperance.primaryTitleColor = UIColor.white;
        apperance.primaryBackgroundPressedColor = UIColor.primaryButtonColorPressed;
        return apperance;
    }
}

public func buildOnfidoConfig(config:NSDictionary, appearance: Appearance) throws -> Onfido.OnfidoConfigBuilder {
  let sdkToken:String = config["sdkToken"] as! String
  let flowSteps:NSDictionary? = config["flowSteps"] as? NSDictionary
  let locale:String? = config["locale"] as? String
  let captureDocument:NSDictionary? = flowSteps?["captureDocument"] as? NSDictionary
  let captureFace:NSDictionary? = flowSteps?["captureFace"] as? NSDictionary

  var onfidoConfig = OnfidoConfig.builder()
    .withSDKToken(sdkToken)
    .withAppearance(appearance)

  if let locale = locale {
    let tableName = config["localizationTable"] as? String ?? "Onfido_"
    onfidoConfig = onfidoConfig.withCustomLocalization(andTableName: "\(tableName)\(locale)")
  }

  if flowSteps?["welcome"] as? Bool == true {
    onfidoConfig = onfidoConfig.withWelcomeStep()
  }

  if let docType = captureDocument?["docType"] as? String {
     let countryCode = captureDocument?["countryCode"] as? String
     switch docType {
      case "PASSPORT":
        onfidoConfig = onfidoConfig.withDocumentStep(ofType: .passport(config: PassportConfiguration()))
      case "DRIVING_LICENCE":
        let stepConfig = countryCode.map(DrivingLicenceConfiguration.init(country:))
        onfidoConfig = onfidoConfig.withDocumentStep(ofType: .drivingLicence(config: stepConfig))
      case "NATIONAL_IDENTITY_CARD":
        let stepConfig = countryCode.map(NationalIdentityConfiguration.init(country:))
        onfidoConfig = onfidoConfig.withDocumentStep(ofType: .nationalIdentityCard(config: stepConfig))
      case "RESIDENCE_PERMIT":
        let stepConfig = countryCode.map(ResidencePermitConfiguration.init(country:))
        onfidoConfig = onfidoConfig.withDocumentStep(ofType: .residencePermit(config: stepConfig))
      case "VISA":
        let stepConfig = countryCode.map(VisaConfiguration.init(country:))
        onfidoConfig = onfidoConfig.withDocumentStep(ofType: .visa(config: stepConfig))
      case "WORK_PERMIT":
        let stepConfig = countryCode.map(WorkPermitConfiguration.init(country:))
        onfidoConfig = onfidoConfig.withDocumentStep(ofType: .workPermit(config: stepConfig))
      case "GENERIC":
        let stepConfig = countryCode.map(GenericDocumentConfiguration.init(country:))
        onfidoConfig = onfidoConfig.withDocumentStep(ofType: .generic(config: stepConfig))
      default:
        throw NSError(domain: "Unsupported document type", code: 0)
    }
  } else if captureDocument != nil {
    onfidoConfig = onfidoConfig.withDocumentStep()
  }

  if let faceVariant = captureFace?["type"] as? String {
    if faceVariant == "VIDEO" {
      onfidoConfig = onfidoConfig.withFaceStep(ofVariant: .video(withConfiguration: VideoStepConfiguration(showIntroVideo: true, manualLivenessCapture: false)))
    } else if faceVariant == "PHOTO" {
      onfidoConfig = onfidoConfig.withFaceStep(ofVariant: .photo(withConfiguration: PhotoStepConfiguration(showSelfieIntroScreen: true)))
    } else {
      throw NSError(domain: "Invalid or unsupported face variant", code: 0)
    }
  }
  return onfidoConfig;
}

@objc(OnfidoSdk)
class OnfidoSdk: NSObject {

  @objc static func requiresMainQueueSetup() -> Bool {
    return false
  }

  @objc func start(_ config: NSDictionary, channel: FlutterMethodChannel, result: @escaping FlutterResult) -> Void {
    DispatchQueue.main.async {
      let withConfig = config["config"] as! NSDictionary
      let withAppearance = config["appearance"] as! NSDictionary
      let listenToUserEvents = config["listenToUserEvents"] as? Bool ?? false

      self.run(withConfig: withConfig,
               withAppearance: withAppearance,
               listenToUserEvents: listenToUserEvents,
               channel: channel,
               result: result)
    }
  }

  private func run(withConfig config: NSDictionary, withAppearance appearanceConfig: NSDictionary, listenToUserEvents: Bool, channel: FlutterMethodChannel, result: @escaping FlutterResult) {

    do {
      let appearance = try loadAppearanceFromConfig(config: appearanceConfig)
      let onfidoConfig = try buildOnfidoConfig(config: config, appearance: appearance)
      let builtOnfidoConfig = try onfidoConfig.build()

      //  Copy the face varient from the config since it is not contained in the response:
      let flowSteps:NSDictionary? = config["flowSteps"] as? NSDictionary
      let captureFace:NSDictionary? = flowSteps?["captureFace"] as? NSDictionary
      let faceVariant = captureFace?["type"] as? String

      var onfidoFlow = OnfidoFlow(withConfiguration: builtOnfidoConfig)

      if (listenToUserEvents) {
        onfidoFlow = onfidoFlow
          .with(eventHandler: { [weak channel] event in
            let arguments: [String: Any] = [
              "name": event.name,
              "properties": event.properties
            ]
            channel?.invokeMethod("event", arguments: arguments)
          })
      }

      onfidoFlow = onfidoFlow
        .with(responseHandler: { [weak self] response in
            guard self != nil else { return }
          switch response {
            case let .error(error):
              result(FlutterError(code: "error", message: "Encountered an error: \(error)", details: nil))
              return;
            case let .success(results):
              result(createResponse(results, faceVariant: faceVariant))
              return;
            case .cancel:
              result(FlutterError(code: "cancel", message: "User canceled flow", details: nil))
              return;
            default:
              result(FlutterError(code: "error", message: "Unknown error has occured", details: nil))
              return;
          }
        })

      let onfidoRun = try onfidoFlow.run()
       UIApplication.shared.windows.first?.rootViewController?.present(onfidoRun, animated: true)
    } catch let error as NSError {
      result(FlutterError(code: "error", message: error.domain, details: nil))
      return;
    } catch {
      result(FlutterError(code: "error", message: "Error running Onfido SDK", details: nil))
      return;
    }
  }
}

extension UIColor {

    static var primaryColor: UIColor {
        return decideColor(light: UIColor.from(hex: "#353FF4"), dark: UIColor.from(hex: "#3B43D8"))
    }

    static var primaryButtonColorPressed: UIColor {
        return decideColor(light: UIColor.from(hex: "#232AAD"), dark: UIColor.from(hex: "#5C6CFF"))
    }

    private static func decideColor(light: UIColor, dark: UIColor) -> UIColor {
        #if XCODE11
        guard #available(iOS 13.0, *) else {
            return light
        }
        return UIColor { (collection) -> UIColor in
            return collection.userInterfaceStyle == .dark ? dark : light
        }
        #else
        return light
        #endif
    }

    static func from(hex: String) -> UIColor {

        let hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)

        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }

        var color: UInt32 = 0
        scanner.scanHexInt32(&color)

        let mask = 0x000000FF
        let redInt = Int(color >> 16) & mask
        let greenInt = Int(color >> 8) & mask
        let blueInt = Int(color) & mask

        let red = CGFloat(redInt) / 255.0
        let green = CGFloat(greenInt) / 255.0
        let blue = CGFloat(blueInt) / 255.0

        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

extension Appearance {

    static let `default` = Appearance()

}
