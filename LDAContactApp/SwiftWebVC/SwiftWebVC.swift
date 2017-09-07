//
//  SwiftWebVC.swift
//
//  Created by Myles Ringle on 24/06/2015.
//  Transcribed from code used in SVWebViewController.
//  Copyright (c) 2015 Myles Ringle & Sam Vermette. All rights reserved.
//

import WebKit

public protocol SwiftWebVCDelegate: class {
    func didStartLoading()
    func didFinishLoading(success: Bool)
    func didSelectaWord(word:String)
}
public enum SwiftModalWebVCProcessStatus {
    case isLoading, isFinish
}

public class SwiftWebVC: UIViewController {
    
    public weak var delegate: SwiftWebVCDelegate?
    var storedStatusColor: UIBarStyle?
    var buttonColor: UIColor? = nil
    var titleColor: UIColor? = nil
    var closing: Bool! = false
    
    lazy var backBarButtonItem: UIBarButtonItem =  {
        var tempBackBarButtonItem = UIBarButtonItem(image: SwiftWebVC.bundledImage(named: "SwiftWebVCBack"),
                                                    style: UIBarButtonItemStyle.plain,
                                                    target: self,
                                                    action: #selector(SwiftWebVC.goBackTapped(_:)))
        tempBackBarButtonItem.width = 18.0
        tempBackBarButtonItem.tintColor = self.buttonColor
        return tempBackBarButtonItem
    }()
    
    lazy var forwardBarButtonItem: UIBarButtonItem =  {
        var tempForwardBarButtonItem = UIBarButtonItem(image: SwiftWebVC.bundledImage(named: "SwiftWebVCNext"),
                                                       style: UIBarButtonItemStyle.plain,
                                                       target: self,
                                                       action: #selector(SwiftWebVC.goForwardTapped(_:)))
        tempForwardBarButtonItem.width = 18.0
        tempForwardBarButtonItem.tintColor = self.buttonColor
        return tempForwardBarButtonItem
    }()
    lazy var LDAWebActionBarButtonItem: UIBarButtonItem =  {
        var tempLDAWebActionBarButtonItem = UIBarButtonItem(image: SwiftWebVC.bundledImage(named: "SwiftWebVCNext"),
                                                       style: UIBarButtonItemStyle.plain,
                                                       target: self,
                                                       action: #selector(SwiftWebVC.LDAWebAtionButtonTapped(_:)))
        tempLDAWebActionBarButtonItem.width = 18.0
        tempLDAWebActionBarButtonItem.tintColor = UIColor.orange
        return tempLDAWebActionBarButtonItem
    }()
    lazy var refreshBarButtonItem: UIBarButtonItem = {
        var tempRefreshBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.refresh,
                                                       target: self,
                                                       action: #selector(SwiftWebVC.reloadTapped(_:)))
        tempRefreshBarButtonItem.tintColor = self.buttonColor
        return tempRefreshBarButtonItem
    }()
    
    lazy var stopBarButtonItem: UIBarButtonItem = {
        var tempStopBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.stop,
                                                    target: self,
                                                    action: #selector(SwiftWebVC.stopTapped(_:)))
        tempStopBarButtonItem.tintColor = self.buttonColor
        return tempStopBarButtonItem
    }()
    
    lazy var actionBarButtonItem: UIBarButtonItem = {
        var tempActionBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action,
                                                      target: self,
                                                      action: #selector(SwiftWebVC.actionButtonTapped(_:)))
        tempActionBarButtonItem.tintColor = self.buttonColor
        return tempActionBarButtonItem
    }()
    
    lazy var LDAactionBarButtonItem: UIBarButtonItem = {
        var tempActionBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done,
                                                      target: self,
                                                      action: #selector(SwiftWebVC.LDAactionButtonTapped(_:)))
        tempActionBarButtonItem.tintColor = self.buttonColor
        return tempActionBarButtonItem
    }()

    lazy var webView: WKWebView = {
        var tempWebView = WKWebView(frame: UIScreen.main.bounds)
        tempWebView.uiDelegate = self
        tempWebView.navigationDelegate = self
        return tempWebView;
    }()
    
    
    var request: URLRequest!
    
    var navBarTitle: UILabel!
    
    ////////////////////////////////////////////////
    
    func LDAactionButtonTapped(_ sender: AnyObject)
    {
        self.dismiss(animated: true , completion: nil)
    }
    deinit {
        webView.stopLoading()
        self.networkProcess(status: .isFinish)
     
        webView.uiDelegate = nil;
        webView.navigationDelegate = nil;
    }
    
    public convenience init(urlString: String) {
        self.init(pageURL: URL(string: urlString)!)
    }
    
    public convenience init(pageURL: URL) {
        self.init(aRequest: URLRequest(url: pageURL))
    }
    
    public convenience init(aRequest: URLRequest) {
        self.init()
        self.request = aRequest
    }
    
    func loadRequest(_ request: URLRequest) {
        webView.load(request)
    }
    
    ////////////////////////////////////////////////
    // View Lifecycle
    
    override public func loadView() {
        view = webView
        loadRequest(request)
    }
    override public func viewDidLoad() {
        super.viewDidLoad()
     //   self.webView.scrollView.delegate =  self
        self.setupGesture()
        updateToolbarItems()
        print(self.navigationController?.navigationBar.frame.size.height)
        
        
        /*
         hiddenview
        let view = UIView(frame: CGRect(x: (self.navigationController?.navigationBar.frame.size.height)!, y: 0, width: 320, height: 100))
        self.view.addSubview(view)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
 */
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        //hidenavigationBar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)

        assert(self.navigationController != nil, "SVWebViewController needs to be contained in a UINavigationController. If you are presenting SVWebViewController modally, use SVModalWebViewController instead.")
        
        navBarTitle = UILabel()
        navBarTitle.backgroundColor = UIColor.clear
        if presentingViewController == nil {
            if let titleAttributes = navigationController!.navigationBar.titleTextAttributes {
                navBarTitle.textColor = titleAttributes["NSColor"] as! UIColor
            }
        }
        else {
            navBarTitle.textColor = self.titleColor
        }
        navBarTitle.shadowOffset = CGSize(width: 0, height: 1);
        navBarTitle.font = UIFont(name: "HelveticaNeue-Medium", size: 17.0)
        
        navigationItem.titleView = navBarTitle;
        
        super.viewWillAppear(true)
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone) {
            self.navigationController?.setToolbarHidden(false, animated: false)
        }
        else if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) {
            self.navigationController?.setToolbarHidden(true, animated: true)
        }
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone) {
            self.navigationController?.setToolbarHidden(true, animated: true)
        }
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.networkProcess(status: .isFinish)

    }
    
    ////////////////////////////////////////////////
    // Toolbar
    
    func updateToolbarItems() {
        backBarButtonItem.isEnabled = webView.canGoBack
        forwardBarButtonItem.isEnabled = webView.canGoForward
        
        
        let refreshStopBarButtonItem: UIBarButtonItem = webView.isLoading ? stopBarButtonItem : refreshBarButtonItem
        
        let fixedSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        let flexibleSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) {
            
            let toolbarWidth: CGFloat = 250.0
            fixedSpace.width = 35.0
            
            let items: NSArray = [fixedSpace, refreshStopBarButtonItem, fixedSpace, backBarButtonItem,fixedSpace,LDAactionBarButtonItem , fixedSpace, forwardBarButtonItem, fixedSpace, actionBarButtonItem]
            
            let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: toolbarWidth, height: 44.0))
            if !closing {
                toolbar.items = items as? [UIBarButtonItem]
                if presentingViewController == nil {
                    toolbar.barTintColor = navigationController!.navigationBar.barTintColor
                }
                else {
                    toolbar.barStyle = navigationController!.navigationBar.barStyle
                }
                toolbar.tintColor = navigationController!.navigationBar.tintColor
            }
            navigationItem.rightBarButtonItems = items.reverseObjectEnumerator().allObjects as? [UIBarButtonItem]
            
        }
        else {
            let items: NSArray = [fixedSpace, backBarButtonItem, flexibleSpace, forwardBarButtonItem,flexibleSpace,LDAactionBarButtonItem, flexibleSpace, refreshStopBarButtonItem, flexibleSpace, actionBarButtonItem, fixedSpace]
            
            if !closing {
                if presentingViewController == nil {
                    navigationController!.toolbar.barTintColor = navigationController!.navigationBar.barTintColor
                }
                else {
                    navigationController!.toolbar.barStyle = navigationController!.navigationBar.barStyle
                }
                navigationController!.toolbar.tintColor = navigationController!.navigationBar.tintColor
                toolbarItems = items as? [UIBarButtonItem]
            }
        }
    }
    
    
    ////////////////////////////////////////////////
    // Target Actions
    
    func goBackTapped(_ sender: UIBarButtonItem) {
        webView.goBack()
    }
    func LDAWebAtionButtonTapped(_ sender: UIBarButtonItem) {
      //  webView.goForward()
    }

    func goForwardTapped(_ sender: UIBarButtonItem) {
        webView.goForward()
    }
    
    func reloadTapped(_ sender: UIBarButtonItem) {
        webView.reload()
    }
    
    func stopTapped(_ sender: UIBarButtonItem) {
        webView.stopLoading()
        updateToolbarItems()
    }
    
    func actionButtonTapped(_ sender: AnyObject) {
        
        if let url: URL = ((webView.url != nil) ? webView.url : request.url) {
            let activities: NSArray = [SwiftWebVCActivitySafari(), SwiftWebVCActivityChrome()]
            
            if url.absoluteString.hasPrefix("file:///") {
                let dc: UIDocumentInteractionController = UIDocumentInteractionController(url: url)
                dc.presentOptionsMenu(from: view.bounds, in: view, animated: true)
            }
            else {
                let activityController: UIActivityViewController = UIActivityViewController(activityItems: [url], applicationActivities: activities as? [UIActivity])
                
                if floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1 && UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                    let ctrl: UIPopoverPresentationController = activityController.popoverPresentationController!
                    ctrl.sourceView = view
                    ctrl.barButtonItem = sender as? UIBarButtonItem
                }
                
                present(activityController, animated: true, completion: nil)
            }
        }
    }
    
    ////////////////////////////////////////////////
    
    func doneButtonTapped() {
        closing = true
        UINavigationBar.appearance().barStyle = storedStatusColor!
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Class Methods

    /// Helper function to get image within SwiftWebVCResources bundle
    ///
    /// - parameter named: The name of the image in the SwiftWebVCResources bundle
    class func bundledImage(named: String) -> UIImage? {
        let image = UIImage(named: named)
        if image == nil {
            return UIImage(named: named, in: Bundle(for: SwiftWebVC.classForCoder()), compatibleWith: nil)
        } // Replace MyBasePodClass with yours
        return image
    }
    
     var lastContentOffset: CGFloat = 0
    

}
/*
extension SwiftWebVC: UIScrollViewDelegate
{
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.lastContentOffset > scrollView.contentOffset.y) {
            // move up
            self.navigationController?.isNavigationBarHidden = false
  self.navigationController?.isToolbarHidden =  false
        }
        else if (self.lastContentOffset < scrollView.contentOffset.y) {
            // move down
            self.navigationController?.isNavigationBarHidden = true
              self.navigationController?.isToolbarHidden =  true

        }
        
        // update the new position acquired
        self.lastContentOffset = scrollView.contentOffset.y

    }
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.navigationController?.isNavigationBarHidden = false
       self.navigationController?.isToolbarHidden =  false

    }
   
}
 */
extension SwiftWebVC: WKUIDelegate {
    
    // Add any desired WKUIDelegate methods here: https://developer.apple.com/reference/webkit/wkuidelegate
    
}

extension SwiftWebVC: WKNavigationDelegate ,UIGestureRecognizerDelegate{
    
     public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
     return true
    }
    
    func didSelectaWord(_ sender: UITapGestureRecognizer)
    {
        let deadlineTime = DispatchTime.now() + 0.01
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            var selectedWord =  self.webView.evaluateJavaScript("window.getSelection().toString()", completionHandler: { (response, error) in
                
                print(response)
                
                print(error)
                
                
                if response as! String != nil && response as! String != ""
                    {
                
                      //  response = (response as! String).removeWhitespace()
                    self.delegate?.didSelectaWord(word: (response as! String).removeWhitespace())
                }
            })

      

        }
        
    }
    func setupGesture()
    {
       let textRecLongPressGesture =  UILongPressGestureRecognizer(target: self, action: #selector(SwiftWebVC.didSelectaWord(_:)))
        textRecLongPressGesture.minimumPressDuration = 0.5
        textRecLongPressGesture.delegate =  self
        
    //    self.webView.addGestureRecognizer(textRecLongPressGesture)
        let textTapGesture = UITapGestureRecognizer(target: self, action:  #selector(SwiftWebVC.didSelectaWord(_:)))
            textTapGesture.numberOfTapsRequired = 1
         textTapGesture.delegate =  self
      
        self.webView.addGestureRecognizer(textTapGesture)
    }

    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.delegate?.didStartLoading()
        
          self.networkProcess(status: .isLoading)
        updateToolbarItems()
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.delegate?.didFinishLoading(success: true)
          self.networkProcess(status: .isFinish)
        webView.evaluateJavaScript("document.title", completionHandler: {(response, error) in
            self.navBarTitle.text = response as! String?
            self.navBarTitle.sizeToFit()
            self.updateToolbarItems()
        })
        
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.delegate?.didFinishLoading(success: false)
                self.networkProcess(status: .isFinish)
        updateToolbarItems()
    }
    
    func networkProcess(status:SwiftModalWebVCProcessStatus)
    {
        if status == .isLoading
        {
           // SwiftSpinner.show("Loading...")

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        else {
            //isFinish
        //    SwiftSpinner.hide()

        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
}
