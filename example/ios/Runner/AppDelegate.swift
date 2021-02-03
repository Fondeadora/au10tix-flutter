import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    print("===> AppDelegate ")
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let storyboard : UIStoryboard? = UIStoryboard.init(name: "Main", bundle: nil);
    let channel = FlutterMethodChannel(name: "fondeadora.com/au10tix", binaryMessenger: controller.binaryMessenger)
    channel.setMethodCallHandler {
      [weak self] (call: FlutterMethodCall, result: FlutterResult) in
        print("===> AppDelegate method:: \(call.method)")
          switch call.method {
          case "verifyId":
            guard let args = call.arguments as? [String: Any] else { return }
            let vc = storyboard?.instantiateViewController(withIdentifier: "IdentificationVC") as! IdentificationVC
            vc.token = args["token"] as! String
            let aObjNavi = UINavigationController(rootViewController: vc)
            self?.window.rootViewController?.present(aObjNavi, animated: true, completion: nil)
          default:
            result(FlutterMethodNotImplemented)
      }
    }
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
