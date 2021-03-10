//
//  IdentificationTypeVC.swift
//  au10tix_flutter
//
//  Created by Brenda SC on 08/02/21.
//

import Flutter
import UIKit
import Au10tixCore
import Au10tixPassiveFaceLivenessUI
import Au10tixSmartDocumentCaptureUI
import Au10tixPassiveFaceLivenessKit
import Au10tixSmartDocumentCaptureKit
import Au10tixBaseUI
import AVFoundation

final class IdentificationTypeVC: UIViewController {

    //MARK: Properties
    var token: String!
    //TODO: bsc: allow 
    var onlyTake = Constants.IdentificationType.none
    var selectedImage: Constants.ImageType = .frontId
    var identificationSelected = Constants.IdentificationType.none
    var flutterResult: FlutterResult!
    var hasSession = false
    var result = Au10tixResult()
    var loadedToken = false
    
    var spinner = UIActivityIndicatorView(style: .whiteLarge)
    
    //MARK: View Cycle
    override func loadView() {
        //UI
        prepare()
        
        //Au10tix
        setupAu10tix()
        addObserver()
    }

}

//MARK: - UI
extension IdentificationTypeVC {
    private func prepare(){
        view = UIView()
        view.backgroundColor = UIColor.white

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        spinner.color = UIColor.black
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            if self.loadedToken {
                timer.invalidate()
                self.spinner.removeFromSuperview()
                
                if self.hasSession {
                    self.openSDCUIComponent()
                }else {
                    self.dissmissScreen()
                }
            }
        }
    }
    
    private func dissmissScreen() {
        self.flutterResult(nil)
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - Au10tix
extension IdentificationTypeVC {
    
    //MARK: - Initialization
    func setupAu10tix() {
        Au10tixCore.shared.prepare(with: token) { [weak self] result in
            self?.loadedToken = true
            switch result {
            case .success(let sessionID):
                self?.hasSession = true
                debugPrint("sessionID -\(sessionID)")
            case .failure(let error):
                self?.showAlert(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Observer
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleExpirationNotification(_:)),
                                               name: .au10tixCoreTokenExpiration, object: nil)
    }
    
    @objc func handleExpirationNotification(_ sender: Notification) {
        let alert = UIAlertController(title: "Error", message: "Session Is Expired", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
            self.hasSession = false
            self.dismiss(animated: true, completion: nil)
        }))
        
        if var topController = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController {
            if let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.present(alert, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Open DOCUMENTID
    func openSDCUIComponent() {
        let configs = UIComponentConfigs(appLogo: UIImage(),
                                         actionButtonTint: UIColor.green,
                                         titleTextColor: UIColor.white,
                                         errorTextColor: UIColor.red,
                                         canUploadImage: true,
                                         showCloseButton: true)
        
        var subtitle = ""
        if self.result.resultType == Constants.IdentificationType.ine && selectedImage == Constants.ImageType.frontId {
            subtitle = Localization.frontINETitle
        }else if self.result.resultType == Constants.IdentificationType.ine && selectedImage == Constants.ImageType.backId {
            subtitle = Localization.backINETitle
        }else if self.result.resultType == Constants.IdentificationType.passport {
            subtitle = Localization.frontPassportTitle
        }else if self.result.resultType == Constants.IdentificationType.resident && selectedImage == Constants.ImageType.frontId {
            subtitle = Localization.frontFM3Title
        }else if self.result.resultType == Constants.IdentificationType.resident && selectedImage == Constants.ImageType.backId {
            subtitle = Localization.backFM3Title
        }
        
        let controller = SDCViewController(configs: configs, delegate: self, isFrontSide: selectedImage == .frontId, subTitle: subtitle)
        
        present(controller, animated: true, completion:nil)
    }
    
    // MARK: - Open SELFIE
    func openPFLUIComponent() {
        let configs = UIComponentConfigs(appLogo: UIImage(),
                                         actionButtonTint: UIColor.green,
                                         titleTextColor: UIColor.white,
                                         errorTextColor: UIColor.red,
                                         canUploadImage: false,
                                         showCloseButton: true)
        
        let controller = PFLViewController(configs: configs, delegate: self)
        controller.title = Localization.selfieTitle
        present(controller, animated: true, completion: nil)
    }
    
    // MARK: - UIAlertController
    func showAlert(_ text: String) {
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Save Image
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func saveImage(image:UIImage){
        var urlFile = ""
        
        let data = selectedImage == Constants.ImageType.face ? image.highQualityJPEGNSData : image.lowQualityJPEGNSData
        
            debugPrint(">>>>>>>>>>>>> save \(selectedImage.rawValue).png")
            let filename = getDocumentsDirectory().appendingPathComponent("\(selectedImage.rawValue).png")
              urlFile = filename.path
            try? data.write(to: filename, options: .atomic)
        
        
        
        if self.result.resultType == Constants.IdentificationType.passport {
            result.urlFront = urlFile
        }else if self.result.resultType == Constants.IdentificationType.ine || self.result.resultType == Constants.IdentificationType.resident {
            if selectedImage == .frontId {
                result.urlFront = urlFile
            }else{
                result.urlBack = urlFile
            }
        }else{
            result.urlFace = urlFile
        }
        
        if selectedImage == .face {
            let dictionary: [String: String] = [
                "urlFront" : result.urlFront,
                "urlBack" : result.urlBack,
                "urlFace": result.urlFace,
                "type": self.result.resultType.rawValue
            ]
            self.flutterResult(dictionary)
            dismiss(animated: true)
        } else if selectedImage == Constants.ImageType.frontId && (self.result.resultType == Constants.IdentificationType.ine || self.result.resultType == Constants.IdentificationType.resident) {
            selectedImage = .backId
            dismiss(animated: true) {
                self.openSDCUIComponent()
            }
        }else{
            selectedImage = .face
            dismiss(animated: true) {
                self.openPFLUIComponent()
            }
        }
    }
    
    
    
    //MARK: - Face Recognition Error
    // Get Results Text Value
    func getResultText(_ result: PassiveFaceLivenessSessionResult) -> String {
        
        return ["isAnalyzed - \(result.isAnalyzed)",
                "score - \(result.score ?? 0)",
                "quality - \(result.quality ?? 0)",
                "probability - \(result.probability ?? 0)",
                "faceError -\(getFaceErrortStringValue(result.faceError))"].joined(separator: "\n")
    }
    
    // Get FaceError String Value
    func getFaceErrortStringValue(_ error: FaceError?) -> String {
        
        guard let faceError = error else {return "none"}
        
        switch faceError {
        case .faceAngleTooLarge:
            return "faceAngleTooLarge"
        case .faceCropped:
            return "faceCropped"
        case .faceNotFound:
            return "faceNotFound"
        case .faceTooClose:
            return "faceTooClose"
        case .faceTooCloseToBorder:
            return "faceTooCloseToBorder"
        case .faceTooSmall:
            return "faceTooSmall"
        case .internalError:
            return "internalError"
        case .tooManyFaces:
            return "tooManyFaces"
        }
    }
}

// MARK: Au10tixSessionDelegate
extension IdentificationTypeVC: Au10tixSessionDelegate {
    
    func didGetUpdate(_ update: Au10tixSessionUpdate) {
        if let documentSessionUpdate = update as? SmartDocumentCaptureSessionUpdate {
            let result = ["blurScore \(documentSessionUpdate.blurScore)",
                    "reflectionScore \(documentSessionUpdate.reflectionScore)",
                    "idStatus \(documentSessionUpdate.idStatus)",
                    "blurStatus \(documentSessionUpdate.blurStatus)",
                    "reflectionStatus \(documentSessionUpdate.reflectionStatus)",
                    "darkStatus \(documentSessionUpdate.darkStatus)",
                    "StabilityStatus \(getStringValue(documentSessionUpdate.stabilityStatus))"].joined(separator: "\n")
            if documentSessionUpdate.stabilityStatus != .stable {
                debugPrint(result)
            }
        }
    }
    
    func getStringValue(_ error: SmartDocumentCaptureSessionUpdate.StabilityStatus?) -> String {
        
        guard let stabilityStatus = error else {return "none"}
        
        switch stabilityStatus {
        case .stable:
            return "stable"
        case .notStable:
            return "notStable"
        }
    }
    
    func didGetError(_ error: Au10tixSessionError) {
        debugPrint(">>>> Error -\(error)")
    }
    
    func didGetResult(_ result: Au10tixSessionResult) {
      
        if let result = result as? PassiveFaceLivenessSessionResult {
            guard let resultImage = UIImage(data: result.imageData),
                  result.isAnalyzed,
                  result.faceError == nil else {
                
                debugPrint(">>>> Error:: \(getFaceErrortStringValue(result.faceError))")
                return
            }
            debugPrint("Result::\n \(getResultText(result))")
            saveImage(image: resultImage)
        }else if let result = result as? SmartDocumentCaptureSessionResult {
            guard let resultImage = result.image?.uiImage else {
                debugPrint(">>>> Error:: image from SmartDocumentCaptureSessionResult")
                return
            }
            debugPrint("===> before saveImage \(selectedImage.rawValue) ")
            saveImage(image: resultImage)
        }
        
    }
}
