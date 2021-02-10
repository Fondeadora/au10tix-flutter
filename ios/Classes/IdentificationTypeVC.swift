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
    var arrFileNames = [String]()
    var selectedImage: ImageType = .none
    var identificationSelected = IdentificationType.none
    var flutterResult: FlutterResult!
    var hasSession = false
    var result = Au10tixResult()
    
    enum ImageType: String {
        case frontId = "fondeadora_frontId"
        case backId  = "fondeadora_backId"
        case face    = "fondeadora_face"
        case none    = ""
    }
    
    enum IdentificationType: Int {
        case ine
        case passport
        case selfie
        case none
    }
    
    //MARK: View Cycle
    override func loadView() {
        //UI
        prepare()
        
        //Au10tix
        //setupAu10tix()
        //addObserver()
    }

}

//MARK: - UI
extension IdentificationTypeVC {
    private func prepare(){
        
        let w:CGFloat = 300.0
        
        //Text Label
        let titleLbl = UILabel()
        titleLbl.backgroundColor = UIColor.clear
        titleLbl.widthAnchor.constraint(equalToConstant: w).isActive = true
        titleLbl.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        titleLbl.text  = "Selecciona la identificación a probar"
        titleLbl.textColor = UIColor.black
        titleLbl.numberOfLines = 0
        titleLbl.adjustsFontSizeToFitWidth = true
        titleLbl.textAlignment = .center
        
        //INE btn
        let ineBtn = UIButton()
        ineBtn.setTitle("INE", for: .normal)
        ineBtn.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        ineBtn.widthAnchor.constraint(equalToConstant: w).isActive = true
        ineBtn.backgroundColor = .blue
        ineBtn.setTitleColor(UIColor.white, for: .normal)
        ineBtn.tag = IdentificationType.ine.rawValue
        ineBtn.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
       
        //Passport btn
        let passportBtn = UIButton()
        passportBtn.setTitle("Passport", for: .normal)
        passportBtn.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        passportBtn.widthAnchor.constraint(equalToConstant: w).isActive = true
        passportBtn.backgroundColor = .blue
        passportBtn.setTitleColor(UIColor.white, for: .normal)
        passportBtn.tag = IdentificationType.passport.rawValue
        passportBtn.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)

        //Stack View
        let stackView   = UIStackView()
        stackView.axis  = NSLayoutConstraint.Axis.vertical
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing   = 40.0

        stackView.addArrangedSubview(titleLbl)
        stackView.addArrangedSubview(ineBtn)
        stackView.addArrangedSubview(passportBtn)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        
        view = UIView()
        view.backgroundColor = .white
        
        self.view.addSubview(stackView)

        //Constraints
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
}

//MARK: - Actions
extension IdentificationTypeVC {
    
    @objc func buttonTapped(sender : UIButton) {
        debugPrint("====> tag::: \(sender.tag)")
        let dictionary: [String: String] = [
            "urlFront" : "urlFront",
            "urlBack" : "urlBack" ,
            "urlFace": "urlFace"
        ]
        self.flutterResult(dictionary)
        
        return
        
       if (!hasSession) {
            self.showAlert("No tiene session de Au10tix")
            return
        }
        
        selectedImage = .frontId
        switch sender.tag {
            case IdentificationType.ine.rawValue:
                identificationSelected = .ine
                break
            case IdentificationType.passport.rawValue:
                identificationSelected = .passport
                break
            default:
                break
        }
        
        self.openSDCUIComponent()
        
        
    }
    
}

//MARK: - Au10tix
extension IdentificationTypeVC {
    
    //MARK: - Initialization
    func setupAu10tix() {
        Au10tixCore.shared.prepare(with: token) { [weak self] result in
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
                                         titleTextColor: UIColor.green,
                                         errorTextColor: UIColor.green,
                                         canUploadImage: true,
                                         showCloseButton: true)
        
        let controller = SDCViewController(configs: configs, delegate: self, isFrontSide: selectedImage == .frontId)
        present(controller, animated: true, completion:nil)
    }
    
    // MARK: - Open SELFIE
    func openPFLUIComponent() {
        let configs = UIComponentConfigs(appLogo: UIImage(),
                                         actionButtonTint: UIColor.green,
                                         titleTextColor: UIColor.green,
                                         errorTextColor: UIColor.green,
                                         canUploadImage: true,
                                         showCloseButton: true)
        
        let controller = PFLViewController(configs: configs, delegate: self)
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
       /* if let data = image.pngData() {
            let filename = getDocumentsDirectory().appendingPathComponent("\(selectedImage).png")
            arrFileNames.append(filename.path)
            try? data.write(to: filename)
        }*/
        
        if identificationSelected == .passport {
            self.result.resultType = .passport
            self.result.urlFront = "\(selectedImage).png"
        }else if identificationSelected == .ine {
            self.result.resultType = .ine
            if selectedImage == .frontId {
                self.result.urlFront = "\(selectedImage).png"
            }else{
                self.result.urlBack = "\(selectedImage).png"
            }
        }else{
            self.result.urlFace = "\(selectedImage).png"
        }
        
        if selectedImage == .face {
            debugPrint("=====> call Flutter")
            let dictionary: [String: String] = [
                "urlFront" : result.urlFront,
                "urlBack" : result.urlBack,
                "urlFace": result.urlFace
            ]
            self.flutterResult(dictionary)
        } else if selectedImage == .frontId && identificationSelected == .ine {
            self.selectedImage = .backId
            dismiss(animated: false) {
                sleep(2)
                self.openSDCUIComponent()
            }
        }else{
            dismiss(animated: false) {
                sleep(2)
                self.selectedImage = .face
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
        //debugPrint(" update -\(update)")
        
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
            debugPrint("\(selectedImage.rawValue) cool!!!")
            saveImage(image: resultImage)
        }
        
    }
}
