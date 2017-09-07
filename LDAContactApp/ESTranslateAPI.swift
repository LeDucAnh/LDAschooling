//
//  ESTranslateAPI.swift
//  EnglishSociety
//
//  Created by Mac on 11/3/16.
//  Copyright © 2016 LeDucAnh. All rights reserved.
//

import UIKit
import Kanna
import Foundation
//import Fuzi
protocol ESTRanslateAPIDelegate {
    func didCompleteTranslate(result:ESTranslateObject)
}
class ESTranslateAPI: NSObject ,UIWebViewDelegate{
    static var sharedInstance = ESTranslateAPI()
    
    var delegate:ESTRanslateAPIDelegate?
    var webview = UIWebView()
    var helloWorldTimer :Timer?

    var currentCheckingWord :String?
@objc private   func sayHello()
    {
        
        NSLog("hello World")
        let string = self.webview.stringByEvaluatingJavaScript(from: "document.documentElement.outerHTML")!
        let word = ";body=" + self.currentCheckingWord!
        
        //this might cause error

     //   if !string.contains(word)
       // {
         //   return
        //}
        
        if (!string.contains("gt-cd-pos"))
        {
            
            
        }
        else{
            //stop
            
            
        MeaningViewController.sharedInstance.meaningVC.currentExploringWord = currentCheckingWord
    MeaningViewController.sharedInstance.displayMeaningofWordTo( frame: CGRect(x: CGFloat(3.0), y: (UIApplication.shared.keyWindow?.bounds)!.size.height/2 -  400/2, width: (UIApplication.shared.keyWindow?.bounds)!.size.width - 3*2, height: EnglishSocietyConfigurateVaribles.SharedInstance.ScreenSize.height), translateObject: ESTranslateAPI.sharedInstance.getExploringWordResult(string))
            //    self.delegate?.didCompleteTranslate(result:  ESTranslateAPI.sharedInstance.getExploringWordResult(string))
            /*
    MeaningTableViewController.sharedInstance.currentExploringWord = currentCheckingWord

           MeaningTableViewController.sharedInstance.displayMeaningofWordTo( frame: CGRect(x: CGFloat(3.0), y: (UIApplication.shared.keyWindow?.bounds)!.size.height/2 -  400/2, width: (UIApplication.shared.keyWindow?.bounds)!.size.width - 3*2, height: EnglishSocietyConfigurateVaribles.SharedInstance.ScreenSize.height), translateObject: ESTranslateAPI.sharedInstance.getExploringWordResult(string))
        //    self.delegate?.didCompleteTranslate(result:  ESTranslateAPI.sharedInstance.getExploringWordResult(string))
            print(string)
 */
            
            
            DispatchQueue.main.async {
                SwiftSpinner.hide()
                
                
                self.helloWorldTimer?.invalidate()
                self.helloWorldTimer = nil
                self.refreshWebview()
                
                
                
            }
        }
    }

    func refreshWebview()
    {
        var myURLString = "https://translate.google.com/m/translate"
      
        if    let myURL = URL(string: myURLString) {
            
            let req = URLRequest(url: myURL)
            webview.delegate = self
            webview.loadRequest(req as URLRequest)
            //

        }
    }
  private  func readFromCurrentWebview()
    {
        
        
        //       let when = DispatchTime.now() + 0.2 // change 2 to desired number of seconds
        // DispatchQueue.main.asyncAfter(deadline: when) {
        //self.sayHello()
        
        if self.helloWorldTimer == nil
        {
            self.helloWorldTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.sayHello), userInfo: nil, repeats: true)
        }
        let when = DispatchTime.now() + 10 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            DispatchQueue.main.async {
                
                SwiftSpinner.hide()
                self.helloWorldTimer?.invalidate()
                self.helloWorldTimer = nil
                
                self.refreshWebview()
            }      //  }
            
        }
        
        
        return
        
        
        
        
        // }
        
    }

    func RequestGoogleTranslateAPIWebview(_ word:String,language:String = "vi")
    {
    
    
     
        
        if !((UIApplication.shared.keyWindow! as UIWindow).rootViewController?.view.subviews.contains(self.webview))!
        {
            
            (UIApplication.shared.keyWindow! as UIWindow).rootViewController?.view.addSubview(webview)
        }

        webview.frame  = CGRect(x: 0, y: 320, width: 320, height: 200)
        webview.frame  = CGRect(x: -3333, y: -3333, width: 0, height: 0)
        var myURLString = "https://translate.google.com/m/translate#en/translateLANGUAGE/translateWORD"
           myURLString = myURLString.replacingOccurrences(of: "translateLANGUAGE", with: language)
        let URLString = myURLString.replacingOccurrences(of: "translateWORD", with: word)
        if    let myURL = URL(string: URLString) {
            
            let req = URLRequest(url: myURL)
            webview.delegate = self
            webview.loadRequest(req as URLRequest)
           // https://translate.google.com/m/translate
            SwiftSpinner.show("Loading...")
            
            //  DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.currentCheckingWord = word
            
            self.readFromCurrentWebview()
            //}
            
            
            
            
        }
        
  
        
   
        
    }
    var myURLString = "https://translate.google.com.vn/?hl=en&authuser=0#en/en/WORD"
   internal func webViewDidFinishLoad(_ webView: UIWebView) {
     
        if webView.stringByEvaluatingJavaScript(from: "document.readyState") == "complete"
        {
            let string =  webView.stringByEvaluatingJavaScript(from: "document.body.innerHTML")
            print(string)

        }

    }
  internal  func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        return true
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print(error)
    }
   fileprivate func getValueOftag(_ StartTag:String,EndTag:String,valueString:String)->[String]
    {
        
        let query = valueString
        let rePat = StartTag
        let postPat = EndTag
        let regex = try! NSRegularExpression(pattern:"\(rePat)(.*?)\(postPat)", options: [])
        let tmp = query as NSString
        var results = [String]()
        
        regex.enumerateMatches(in: valueString, options: [], range: NSMakeRange(0, (query.characters.count))) { result, flags, stop in
            if let range = result?.rangeAt(1) {
                results.append(tmp.substring(with: range))
            }
        }
        // print(results) // ["test", "test1"]
        return results
        
    }
    
    func getwordDefinitonFrom(_ WebViewHTMLSourceString:String) ->[String]
    {

        let resultDefinition = [String]()
        
return resultDefinition
    }
    
    //method to read html from google translate . 
    //thuc representation 
    //WebViewHTMLSourceString is the whole html string value from google translate website
   func  getExploringWordResult(_ WebViewHTMLSourceString:String) -> ESTranslateObject
    {
        //There you go 
        
        do
        {
            //HTMLDocument is fuzi class 
            //HTMLDocument help reading and parsing html 
            
            //passing WebViewHTMLSourceString to HTMLDocument object to initialize htmldocument object to parse html from WebViewHTMLSourceString string 
            //assign html object as doc
     
            
           let doc = try HTML(html: WebViewHTMLSourceString, encoding: String.Encoding.utf8)
            
          //  let doc = try HTMLDocument(string: WebViewHTMLSourceString, encoding: String.Encoding.utf8)
        // CSS queries
       return   ESTranslateObject.sharedInstance.getObjectfrom(doc: doc!)
        }
        catch
        {
            return ESTranslateObject()
        }
        
    }
    func getwordExploringResult(_ WebViewHTMLSourceString:String)
        -> ([NSArray] ,[String])

    {
        //gt-cd-c
        
        let string = WebViewHTMLSourceString
        
        let outRePat = "<div class=\"KEY\">"
        let outPostPat = "</div>"
        
        
        
        let valuesTypeResultArray =       self.getValueOftag(outRePat.replacingOccurrences(of: "KEY", with: "gt-cd-pos"), EndTag: outPostPat , valueString: string)
        
        
        //gt-cd-pos
        var valuesResultArray =        self.getValueOftag("<div class=\"gt-def-list\" style=\"direction: ltr;\">", EndTag: "<div class=\"gt-cd-pos\">", valueString: string)
//"<div class=\"gt-cd-pos\">"
        
        
        
        if valuesResultArray.count < valuesTypeResultArray.count
        {
            print(valuesTypeResultArray.last)
            
         let lastObject = self.getValueOftag(valuesTypeResultArray.last!, EndTag: "cd-expand-button", valueString: string)
           
            valuesResultArray.append(lastObject.last!)
        }
        
        
        var returnedDefinition = [NSArray]()
//<div class="gt-def-list" style="direction: ltr;"></div>
        for value in valuesResultArray
        {
            //gt-def-row
            //<div class=\"gt-def-row\">
            //<div
            let DefinitionArray =   self.getValueOftag("<div class=\"gt-def-row\">", EndTag: "<div class=\"gt-mt-md\"", valueString: value)
            
            returnedDefinition.append(DefinitionArray as NSArray)
            
            
            
        }
        
        
        return (returnedDefinition,valuesTypeResultArray)

        
    }
    func getwordSynonymFrom(_ WebViewHTMLSourceString:String) ->[String]
    {
      //  if webView.stringByEvaluatingJavaScript(from: "document.readyState") == "complete"
        //{
          //  let string =  webView.stringByEvaluatingJavaScript(from: "document.body.innerHTML")
            
            
            //<div class="gt-def-synonym"> </div>
        
        let string = WebViewHTMLSourceString
        
            let outRePat = "<div class=\"gt-def-synonym\">"
            let outPostPat = "</div>"
            
            let valuesOfSynonymTag =       self.getValueOftag(outRePat, EndTag: outPostPat, valueString: string)
            
            
            var resultSynonym = [String]()
            for synonymTag in valuesOfSynonymTag
            {
                let RePat = "<span>"
                let PostPat = "</span>"
                let synonyms =  self.getValueOftag(RePat, EndTag: PostPat, valueString: synonymTag)
                resultSynonym.append(contentsOf: synonyms)
            }
            
        //    print(resultSynonym)
            
            
       // }
        
        return resultSynonym

    }
    
}
