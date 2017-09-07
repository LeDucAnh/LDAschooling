//
//  ESTranslateWordObject.swift
//  XMLPractice
//
//  Created by Mac on 2/21/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit
import Kanna
import Foundation
//import Fuzi

// ESTranslateWordDefObject  present objet of tag "gt-def-info"
class ESTranslateWordDefObject: NSObject {
   
    //definition of word
    var ESWordString:String = ""

    var ESWordType:String = ""
    //gt-def-row
    var  ESWordDefinition:String = ""
    //gt-def-example
    var ESWordExample:String = ""
    //gt-def-synonym
    var ESWordSynonymsArr = [String]()
    //is the array of object of tag "gt-cd-cl"
    /*
     
   -  this is the class to present a single object that store the definition , example and synonym array .
     so this will have 3 main property , 
     -the first one is ESWordDefinition which is a String will read value of tag gt-def-row from html document
     -the second one is also a string that display an example which bassically is the value of tag "gt-def-example"
the final property is an array which will store all of synonyms of the word we trying to search . 
     so ESWordSynonymsArr is an array of string value from tag gt-def-synonym
     
     
     */
    func getSynonymString()->String
    {
        var text = ""
        for item in self.ESWordSynonymsArr
        {
            
            
            text = text + " ," + item
        }
        return text

    }
    func getValueString()->String
    {
        var text =   self.ESWordDefinition + "\nExample : \""  +  self.ESWordExample + "\""
        
        if self.ESWordSynonymsArr.count != 0
        {
         text =  text   + "\nSynonyms : "
        }
        
      text =    text + self.getSynonymString()
        
        
        return text
    }
     init(def:String,example :String,Synonyms:[String]) {
        super.init()
        self.ESWordDefinition = def
        self.ESWordExample =  example
        self.ESWordSynonymsArr =  Synonyms
    }
    
    //xml element is from fuzi 
    
    //init function will return the object self
    init(htmsecificLanguageDoc:XMLElement)
    {
        super.init()
        //gt-baf-cell
        //gt-baf-word-selected   span 
        //gt-baf-cell gt-baf-word span
        
       

        print(htmsecificLanguageDoc.text)
        
        self.ESWordDefinition = htmsecificLanguageDoc.text!

    }
    
    init(htmlDoc : XMLElement) {
        super.init()
        
        //htmlDoc
        
        //(1)assign gt-def-row value for ESWordDefinition
        
        
    self.ESWordDefinition =   (htmlDoc.xpath("div[@class=\"gt-def-row\"]").first?.text)!
        
        
        //(2)check if htmldoc contain example
        if let example = (htmlDoc.xpath("div[@class=\"gt-def-example\"]").first?.text)
        {
                    //assign gt-def-example value for ESWordExample
        self.ESWordExample = example
        }
        
        //check if htmldoc contain synonyms
        for synonym  in htmlDoc.xpath("div[@class=\"gt-def-synonym\"]")
        {
            print("----------------")

            for element  in synonym.xpath("span")
            {
                //get <span></span> tag value only
                //(4)
                
              print( element["attr"])
                print(element.className)
               // if element.attributes.count == 0          {
                
                
                if element.className == "gt-cd-ncl"
                {
                    //append is add to array
                    self.ESWordSynonymsArr.append(element.text!)
                }
 
                //}
            }
        }
    }
    //(1) we will read the value from tag gt-def-row then assign the value to ESWordDefinition property
    //(2)then we will check if html contain gt-def-example tag value . if yes , it will assign value to example temporary value
    //when we have "example temporary value" we will assign it to eswordexample property
    //(3) we will loop through gt-def-synonym tag in html document . 
    //in side the gt-def-synonym we will create one more loop to loop thorugh span tag to get the raw string  value from span tag 
    //after we have the span value we will have to check that if span value has any attribute . if not (which mean element.attributes.count == 0  then we will get the raw value of the element to add to the ESWordSynonymsArr
    

    

}
