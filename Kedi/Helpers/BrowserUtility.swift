//
//  BrowserUtility.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/18/24.
//

import UIKit
import SwiftUI
import SafariServices

final class BrowserUtility {
    
    static func openUrlInApp(
        urlString: String,
        modalPresentationStyle: UIModalPresentationStyle = .pageSheet
    ) {
        guard let url = URL(string: urlString),
              let topController = UIApplication.topController() else {
            return
        }
        
        let safariController = SFSafariViewController(url: url)
        safariController.modalPresentationStyle = modalPresentationStyle
        topController.present(safariController, animated: true, completion: nil)
    }
    
    static func openUrlOutsideApp(urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        UIApplication.shared.open(url)
    }
}

extension UIApplication {
    
    // https://stackoverflow.com/a/68989580/9212388
    var keyWindow: UIWindow? {
        connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }
    
    static func topController(
        controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
    ) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topController(controller: navigationController.visibleViewController)
        }
        
        if let tabController = controller as? UITabBarController,
           let selected = tabController.selectedViewController {
            return topController(controller: selected)
        }
        
        if let presented = controller?.presentedViewController {
            return topController(controller: presented)
        }
        
        return controller
    }
}

private struct SFSafariViewControllerViewModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .environment(\.openURL, OpenURLAction { url in
                BrowserUtility.openUrlInApp(urlString: url.absoluteString)
                return .handled
            })
    }
}

extension View {
    
    func openUrlInApp() -> some View {
        modifier(SFSafariViewControllerViewModifier())
    }
}
