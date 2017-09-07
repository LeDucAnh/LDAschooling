//
//  ESTranslateObject.swift
//  XMLPractice
//
//  Created by Mac on 2/21/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//
//fuzi is a third party from github to parse xml & html by using xpath or xquery string
//url : https://github.com/cezheng/Fuzi

import UIKit
import Kanna
import Foundation
//import Fuzi

class ESTranslateObject: NSObject {
//
    //number of item in wordtype always =  item worddeflest
    
    
    var wordMeaning : String!
    //this value present word type from html document form google translate . which the tag is gt-cd-pos
    var wordType = [String]()
    
    //is an array to store word defition which tag is gt-def-list
    var wordDefLists = [[ESTranslateWordDefObject]]()
    
    var specificLanguagewordType = [String]()
    var specificLanguagewordDefLists = [[ESTranslateWordDefObject]]()
    //this is an share object which is singleton design pattern 
    //this property whill allow other class to access functions in this class .
    static let sharedInstance = ESTranslateObject()
    override init() {
        super.init()
    }
    func getTotalObject() -> Int
    {
        var totalObj =  0
        for item in wordDefLists
        {
            totalObj += item.count
        
        }
        return totalObj
    }
    /*
    init(wordTypesHTMLValue:NodeSet,wordDefHTMLValue:NodeSet) {
    super.init()
        
    }
    */
    //main function
    func getObjectfrom(doc : HTMLDocument)->ESTranslateObject
    {
    
        //remove all previous value out of the arrays 
        
            wordType.removeAll()
            wordDefLists.removeAll()
        specificLanguagewordType.removeAll()
        specificLanguagewordDefLists.removeAll()
        
        //initialize an array 
        
        var DefTypeArr = [Any]()
        
      //  var SynTypeArr = [Any]()
        //var SynArr = [Any]()
        
        
       
        
        
        for x in doc.xpath("//div[@class=\"frame\"]/div[@class=\"page\"]/div[@class=\"cllist\"]/div[@class=\"gt-lc gt-lc-mobile\"]/div[@class=\"gt-cc\"]/div[@class=\"gt-cc-r\"]/div[@class=\"gt-cc-r-i\"]")
        {
         
            //=------------
           for defType  in x.xpath("//div/div/div[@class=\"gt-baf-cell gt-baf-pos-head\"]/span[@class=\"gt-cd-pos\"]")
            {//gt-cd-c
                //class="gt-baf-cell gt-baf-pos-head"
                //gt-cd-pos
                print(defType.text!)
                //for every wordtype from tag gt-cd-pos we will add to DefTypeArr
                specificLanguagewordType.append(defType.text!)
                
            }
            var iSpecificLang = 0
            for defRes  in x.xpath("//div[@class=\"gt-cd gt-cd-mbd gt-cd-baf\"]/div[@class=\"gt-cd-c\"]/div/div[@class=\"gt-baf-pos-section\"]")
            {//gt-cd-c
                //class="gt-baf-cell gt-baf-pos-head"
                //gt-cd-pos
                
                //create an array to store all defition in gt-def-list
                print(defRes.text!)
                var DefArr = [ESTranslateWordDefObject]()
                
                
                for def in defRes.xpath("//span[@class=\"gt-baf-cell gt-baf-word\"]")
                {
                    let DefObject = ESTranslateWordDefObject(htmsecificLanguageDoc: def)
                    DefObject.ESWordType = specificLanguagewordType[iSpecificLang] as! String
                    DefArr.append(DefObject)


                }
                
                print(defRes.text!)
                //for every wordtype from tag gt-cd-pos we will add to DefTypeArr
                //      specificLanguagewordDefLists.append(defRes.stringValue)
                specificLanguagewordDefLists.append(DefArr)
                
                iSpecificLang = iSpecificLang + 1
            }
            //------------------------------
          
            
            
            
            
            
            //read all of wordtype value
            for defType  in x.xpath("//div[@class=\"gt-cd gt-cd-mmd\"]/div[@class=\"gt-cd-c\"]/div[@class=\"gt-cd-pos\"]")
                {
          //  print(defType.stringValue)
                    //for every wordtype from tag gt-cd-pos we will add to DefTypeArr
            DefTypeArr.append(defType.text!)
            
                }
        
            
            //in this loop we will loop through every object which tag dt-def-list in gt-cd-c tag  - : dash
              var i = 0
            for defResult  in x.xpath("//div[@class=\"gt-cd gt-cd-mmd\"]/div[@class=\"gt-cd-c\"]/div[@class=\"gt-def-list\"]")
            {
                
                //in every single time we have gt-def-list value
                print(defResult.text!)
                
                //create an array to store all defition in gt-def-list
                var DefArr = [ESTranslateWordDefObject]()

              
                for def in defResult.xpath("div[@class=\"gt-def-info\"]")

                {
                let DefObject = ESTranslateWordDefObject(htmlDoc: def)
                print(defResult)
                    DefObject.ESWordType = DefTypeArr[i] as! String
                    DefArr.append(DefObject)
                
                }
                 self.wordDefLists.append(DefArr as! [ESTranslateWordDefObject])
                i += 1
            }
        }
        
       
        self.wordType = DefTypeArr as! [String]
        
        return self
    }
}
