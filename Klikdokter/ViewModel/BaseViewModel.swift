//
//  BaseViewModel.swift
//  Klikdokter
//
//  Created by Hai Hoang on 24/02/2022.
//

import UIKit
import RxSwift
import RxCocoa

class BaseViewModel: NSObject {
    let isLoadingValue = BehaviorRelay<Bool>(value: false)
    let errorMessage = BehaviorRelay<String?>(value: nil)
}
