//
//  Constants.swift
//  Klikdokter
//
//  Created by Hai Hoang on 24/02/2022.
//

import UIKit
import RxCocoa
import RxSwift

struct Constants {
    struct Endpoint {
        static let BaseUrl = "https://hoodwink.medkomtek.net/api/"
    }
    
    struct ScreenSize {
        static let ScreenWidth = UIScreen.main.bounds.size.width
        static let ScreenHeight = UIScreen.main.bounds.size.height
        static let ScreenMaxLength = max(ScreenSize.ScreenWidth, ScreenSize.ScreenHeight)
        static let ScreeninLength = min(ScreenSize.ScreenWidth, ScreenSize.ScreenHeight)
    }
}

// Only for demo purpose, once the app is restarted, needs to login/register again
var currentLoggedInToken = BehaviorRelay<String>(value: "")
