//
//  SwiftModalWebVC.swift
//
//  Created by Myles Ringle on 24/06/2015.
//  Transcribed from code used in SVWebViewController.
//  Copyright (c) 2015 Myles Ringle & Oliver Letterer. All rights reserved.
//

import UIKit


extension SwiftModalWebVC
{
    public func didStartLoading() {
        
       // self.webViewDelegate?.WebVCdidStartLoading?()
    }
    public func didSelectaWord(word: String) {
        self.webViewDelegate.didSelectaWordAction(word)
     //   self.webViewDelegate?.WebVCdidSelectaWord?(word: word)
    }
    public func didFinishLoading(success: Bool) {
   //     self.webViewDelegate?.WebVCdidFinishLoading?(success: success)
     
    }
    
}
/*
@objc protocol SwiftModalWebVCDelegate :  UIWebViewDelegate
{
    @objc optional func WebVCdidStartLoading()
  @objc optional  func WebVCdidSelectaWord(word: String)
   @objc optional func WebVCdidFinishLoading(success: Bool)
}
*/

public enum SwiftModalWebVCDelegateAction
{
    case didSelectaWord
    case didStartLoading
    case didFinishLoading
}
/*
public class SwiftModalWebVCDelegateReturnType
{
    class func SwiftModalWebVCDelegateAction(action:SwiftModalWebVCDelegateAction)->Any
    {
        if action == .didSelectaWord
        {
            var action =   ((word: String)->Void).self
            
            return action
            
            
        }
        
        return (()->Void).self
    }
    
}
 */
public class SwiftModalWebVCDelegate
{
    var didSelectaWordAction : ((_ word: String)->Void)!
    
    func registerFordidSelectaWord( callbackAction:@escaping (_ word: String)->Void)
    {
            self.didSelectaWordAction =   callbackAction
        
    }
    
}

public class SwiftModalWebVC: UINavigationController,SwiftWebVCDelegate {
 
    public enum SwiftModalWebVCTheme {
        case lightBlue, lightBlack, dark
    }
    
     var webViewDelegate = SwiftModalWebVCDelegate()
    
    public convenience init(urlString: String) {
        self.init(pageURL: URL(string: urlString)!)
    }
    
    public convenience init(urlString: String, theme: SwiftModalWebVCTheme) {
        self.init(pageURL: URL(string: urlString)!, theme: theme)
    }
    
    public convenience init(pageURL: URL) {
        self.init(request: URLRequest(url: pageURL))
    }
    
    public convenience init(pageURL: URL, theme: SwiftModalWebVCTheme) {
        self.init(request: URLRequest(url: pageURL), theme: theme)
    }
    
    public init(request: URLRequest, theme: SwiftModalWebVCTheme = .lightBlue) {
        let webViewController = SwiftWebVC(aRequest: request)
      
        webViewController.webView.scrollView.contentSize = CGSize(width: EnglishSocietyConfigurateVaribles.SharedInstance.ScreenSize.width, height: webViewController.webView.scrollView.contentSize.height)
        webViewController.storedStatusColor = UINavigationBar.appearance().barStyle

        let doneButton = UIBarButtonItem(image: SwiftWebVC.bundledImage(named: "SwiftWebVCDismiss"),
                                         style: UIBarButtonItemStyle.plain,
                                         target: webViewController,
                                         action: #selector(SwiftWebVC.doneButtonTapped))
        
        switch theme {
        case .lightBlue:
            doneButton.tintColor = nil
            webViewController.buttonColor = nil
            webViewController.titleColor = UIColor.black
            UINavigationBar.appearance().barStyle = UIBarStyle.default
        case .lightBlack:
            doneButton.tintColor = UIColor.darkGray
            webViewController.buttonColor = UIColor.darkGray
            webViewController.titleColor = UIColor.black
            UINavigationBar.appearance().barStyle = UIBarStyle.default
        case .dark:
            doneButton.tintColor = UIColor.white
            webViewController.buttonColor = UIColor.white
            webViewController.titleColor = UIColor.groupTableViewBackground
            UINavigationBar.appearance().barStyle = UIBarStyle.black
        }
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) {
            webViewController.navigationItem.leftBarButtonItem = doneButton
        }
        else {
            webViewController.navigationItem.rightBarButtonItem = doneButton
        }
        
        
        super.init(rootViewController: webViewController)
          webViewController.delegate =  self
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
    }
}
