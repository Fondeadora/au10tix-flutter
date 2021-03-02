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
    guard let args = call.arguments as? [String: Any], let jwtKey = args["token"] as? String else { return result(nil) }

    debugPrint("====> SwiftAu10tixFlutterPlugin initializeSdk  jwtKey:: \(jwtKey)")
    let window: UIWindow = ((UIApplication.shared.delegate?.window)!)!
    let identificationVC = IdentificationTypeVC()
    identificationVC.token = jwtKey
    identificationVC.flutterResult = result
    identificationVC.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
    window.rootViewController!.present(identificationVC, animated: true, completion: nil)
    
  }
}

