//
//  String+Extension.swift
//  au10tix_flutter
//
//  Created by Brenda SC on 26/02/21.
//

import Foundation

struct Localization {
    
    static let isSpanish = Locale.preferredLanguages[0].starts(with: "es") ? true : false
    
    static var frontINETitle : String {
        if Localization.isSpanish {
            return "Escanea el frente de tu INE"
        }else{
            return "Scan the front side of your INE"
        }
    }
    
    static var backINETitle : String {
        if Localization.isSpanish {
            return "Escanea el reverso de tu INE"
        }else{
            return "Scan the back side of your INE"
        }
    }
    
    static var frontPassportTitle : String {
        if Localization.isSpanish {
            return "Escanea tu pasaporte"
        }else{
            return "Scan your passport"
        }
    }
    
    static var frontFM3Title : String {
        if Localization.isSpanish {
            return "Escanea el frente tu FM2 ó FM3"
        }else{
            return "Scan the front side of your FM2 or FM3"
        }
    }
    
    static var backFM3Title : String {
        if Localization.isSpanish {
            return "Escanea el reverso tu FM2 ó FM3"
        }else{
            return "Scan the back side of your FM2 or FM3"
        }
    }
    
    static var selfieTitle : String {
        if Localization.isSpanish {
            return "Tómate una selfie"
        }else{
            return "Take a selfie"
        }
    }
    
    
}

struct Constants {
    
    enum IdentificationType: String {
        case ine = "ine"
        case passport = "passport"
        case selfie = "selfie"
        case resident = "residentCard"
        case none = "none"
    }
    
    enum ImageType: String {
        case frontId = "fondeadora_frontId"
        case backId  = "fondeadora_backId"
        case face    = "fondeadora_face"
        case none    = ""
    }
    
    
}
