import Flutter
import UIKit
import Au10tixCore
import Au10tixPassiveFaceLivenessUI
import AVFoundation

public class SwiftAu10tixFlutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "au10tix_flutter", binaryMessenger: registrar.messenger())
    let instance = SwiftAu10tixFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    print("====> SwiftAu10tixFlutterPlugin handle")
    guard call.method == "verifyId" else {
        result(FlutterMethodNotImplemented)
        return
    }
    guard let args = call.arguments as? [String: Any] else { return }
    self.initializeSdk(jwtKey: args["token"] as! String)
    
  }
    
  private func initializeSdk(jwtKey: String) {
    print("====> SwiftAu10tixFlutterPlugin initializeSdk  jwtKey:: \(jwtKey)")
    let window: UIWindow = ((UIApplication.shared.delegate?.window)!)!
    let vc = ViewController()
    vc.token = jwtKey
    window.rootViewController!.present(vc, animated: true, completion: nil)
  }
    
}

class ViewController: UIViewController {

    var token: String!
    
    override func loadView() {
        // super.loadView()   // DO NOT CALL SUPER
        print("====> loadView")
        view = UIView()
        view.backgroundColor = .lightGray
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = token
        view.addSubview(label)
    }
}
