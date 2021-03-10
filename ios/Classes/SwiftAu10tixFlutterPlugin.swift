import Flutter
import UIKit
import Au10tixCore
import Au10tixPassiveFaceLivenessUI
import Au10tixSmartDocumentCaptureUI
import Au10tixPassiveFaceLivenessKit
import Au10tixBaseUI
import AVFoundation


public class SwiftAu10tixFlutterPlugin: NSObject, FlutterPlugin {
     
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "au10tix_flutter", binaryMessenger: registrar.messenger())
    let instance = SwiftAu10tixFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    debugPrint("====> SwiftAu10tixFlutterPlugin handle")
    
    guard call.method == "verifyId" else {
        result(FlutterMethodNotImplemented)
        return result(nil)
    }
    guard let args = call.arguments as? [String: Any], let jwtKey = args["token"] as? String, let identification = args["identification"] as? String else { return result(nil) }

    debugPrint("====> SwiftAu10tixFlutterPlugin initializeSdk  jwtKey:: \(jwtKey)")
    let window: UIWindow = ((UIApplication.shared.delegate?.window)!)!
    let identificationVC = IdentificationTypeVC()
    identificationVC.token = jwtKey
    identificationVC.result = getResult(identification: identification.lowercased())
    identificationVC.flutterResult = result
    identificationVC.modalPresentationStyle = .fullScreen
    window.rootViewController!.present(identificationVC, animated: true, completion: nil)
    
  }
    
    private func getResult(identification: String) -> Au10tixResult {
        let result = Au10tixResult()
        var resultType = Constants.IdentificationType.none
        if(identification == Constants.IdentificationType.passport.rawValue.lowercased()) {
            resultType = Constants.IdentificationType.passport
        }else if(identification == Constants.IdentificationType.ine.rawValue.lowercased()) {
            resultType = Constants.IdentificationType.ine
        }else if(identification == Constants.IdentificationType.resident.rawValue.lowercased()) {
            resultType = Constants.IdentificationType.resident
        }else if(identification == Constants.IdentificationType.selfie.rawValue.lowercased()) {
            resultType = Constants.IdentificationType.selfie
        }
        result.resultType = resultType
        
        return result
    }
}

