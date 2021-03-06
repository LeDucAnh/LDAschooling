//
//  Simplicity.swift
//  Simplicity
//
//  Created by Edward Jiang on 5/10/16.
//  Copyright © 2016 Stormpath. All rights reserved.
//

import UIKit
import SafariServices

/// Callback handler after an external login completes.
public typealias ExternalLoginCallback = (String?, NSError?) -> Void

/** 
 Simplicity is a framework for authenticating with external providers on iOS.
 */
public final class Simplicity {
    fileprivate static var currentLoginProvider: LoginProvider?
    fileprivate static var callback: ExternalLoginCallback?
    fileprivate static var safari: UIViewController?
    
    /**
     Begin the login flow by redirecting to the LoginProvider's website.
     
     - parameters:
       - loginProvider: The login provider object configured to be used.
       - callback: A callback with the access token, or a SimplicityError.
     */
    public static func login(_ loginProvider: LoginProvider, callback: @escaping ExternalLoginCallback) {
        self.currentLoginProvider = loginProvider
        self.callback = callback
        
        presentSafariView(loginProvider.authorizationURL)
    }
    
    /// Deep link handler (iOS9)
    public static func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey: Any]) -> Bool {
        safari?.dismiss(animated: true, completion: nil)
        guard let callback = callback, url.scheme == currentLoginProvider?.urlScheme else {
            return false
        }
        currentLoginProvider?.linkHandler(url, callback: callback)
        currentLoginProvider = nil
        
        return true
    }
    
    /// Deep link handler (<iOS9)
    public static func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return self.application(application, open: url, options: [UIApplicationOpenURLOptionsKey: Any]())
    }
    
    fileprivate static func presentSafariView(_ url: URL) {
        if #available(iOS 9, *) {
            safari = SFSafariViewController(url: url)
            var topController = UIApplication.shared.keyWindow?.rootViewController
            while let vc = topController?.presentedViewController {
                topController = vc
            }
            topController?.present(safari!, animated: true, completion: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
