//
//  ViewControllerExtension.swift
//  Klikdokter
//
//  Created by Hai Hoang on 24/02/2022.
//

import UIKit
import NVActivityIndicatorView

let loadingViewTag = 999

extension UIViewController {
    func showLoadingView() {
        
        if let topController = UIApplication.topViewController() {
            
            for view in topController.view.subviews where view.tag == loadingViewTag {
                view.removeFromSuperview()
            }
            
            let loadingView = UIView(frame: topController.view.bounds)
            loadingView.tag = loadingViewTag
            loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            
            let spinningView = NVActivityIndicatorView(frame: CGRect(x: loadingView.center.x - 25, y: loadingView.center.y - 25, width: 50, height: 50), type: .ballPulse, color: UIColor.white, padding: nil)
            loadingView.addSubview(spinningView)
            
            topController.view.addSubview(loadingView)
            
            spinningView.startAnimating()
        }
    }
    
    func removeLoadingView() {
        if let topController = UIApplication.topViewController(), let loadingView = topController.view.viewWithTag(loadingViewTag) {
            loadingView.removeFromSuperview()
        }
    }
    
    func showLoadingValue(_ shown: Bool) {
        DispatchQueue.main.async {
            if shown {
                self.showLoadingView()
            } else {
                self.removeLoadingView()
            }
        }
    }
    
    func showAlert(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController, let selected = tabController.selectedViewController {
            return topViewController(controller: selected)
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
