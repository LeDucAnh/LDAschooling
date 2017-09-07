//
//  DemoCell.swift
//  FoldingCell
//
//  Created by Alex K. on 25/12/15.
//  Copyright © 2015 Alex K. All rights reserved.
//

import UIKit
import Foundation
class MeaningCell: FoldingCell {
  

    @IBAction func MeaningCell_DefinitionSpeakButtonTapped(_ sender: Any) {
        
        
        ESSpeakerHelper.sharedInstance.speak(speakingString: self.MeaningCellBackWorDefinitionLabel.text!)
    }
    
    @IBAction func MeaningCell_ExampleSpeakButtonTapped(_ sender: Any) {
          ESSpeakerHelper.sharedInstance.speak(speakingString: self.MeaningCellBackWordExampleLabel.text!)
    }
    @IBAction func MeaningCell_SynonymsSpeakButtonTapped(_ sender: Any) {
          ESSpeakerHelper.sharedInstance.speak(speakingString: self.MeaningCellBackWordSynonymLabel.text!)
        
        
    }
    @IBOutlet weak var MeaningCell_FrontWordTypeLabel: UILabel!
    @IBOutlet weak var MeaningCell_FrontWordDefinitionLabel: UILabel!
    
    @IBOutlet weak var MeaningCell_BackWordType: UILabel!
    @IBOutlet weak var MeaningCellBackWorDefinitionLabel: UILabel!
    @IBOutlet weak var MeaningCellBackWordExampleLabel: UILabel!
    @IBOutlet weak var MeaningCellBackWordSynonymLabel: UILabel!
  static let sharedInstance = MeaningCell()
  var number: Int = 0 {
    didSet {
     
    
    }
  }
    var currentExploringWordObj:ESTranslateWordDefObject?
    func getSectionAndIndexOfCell(cellIndex:Int,translateObject:ESTranslateObject)-> (Int,Int)
    {
        var i  = 0
        var tempIndex = cellIndex
        while tempIndex >= translateObject.wordDefLists[i].count
        {
            tempIndex = tempIndex - translateObject.wordDefLists[i].count
            i = i + 1
            if tempIndex == translateObject.wordDefLists[i].count - 1
            {
                
             return (i,tempIndex)
                break
                
            }
        }
        
        if tempIndex >= translateObject.wordDefLists[i].count
        {
            tempIndex -= 1
        }
        return (i,tempIndex)
        
    }
    func setDataFromTranlateObject(translateObject:ESTranslateObject,cellIndex:Int)
    {
   let (section,index) =   self.getSectionAndIndexOfCell(cellIndex: cellIndex, translateObject: translateObject)
        self.MeaningCell_FrontWordTypeLabel.text = translateObject.wordType[section]
        print(section)
        print(index)
        let def = (translateObject.wordDefLists[section][index])
        self.currentExploringWordObj  =  def
        self.MeaningCell_FrontWordDefinitionLabel.text =  def.ESWordDefinition
        //self.MeaningCell_FrontWordDefinitionLabel.text = "asdfsdafadsfadsfadsfadsfsadfasdfadsf'adsfsaasdfadsfsad sdfadsfsad" +  def.ESWordDefinition
        
        self.MeaningCellBackWordExampleLabel.text = "Example : " +  def.ESWordExample
        self.MeaningCell_BackWordType.text = translateObject.wordType[section]
        self.MeaningCellBackWordSynonymLabel.text = "Synonym : " + def.getSynonymString()
        self.MeaningCellBackWorDefinitionLabel.text = def.ESWordDefinition
        
        
        //newline code
        //ESTranslateObject has new property name ESWordType
        self.MeaningCell_BackWordType.text = def.ESWordType + " "
        
        self.MeaningCell_FrontWordTypeLabel.text = def.ESWordType
        
    }
    /*
    
    func setDataFromSavedVocabularyObj(word:CoreDataESWord)
    {
        self.MeaningCell_FrontWordDefinitionLabel.text =  word.wordDef
        
        
        self.MeaningCellBackWordExampleLabel.text = "Example : " + word.wordExample!
      
        self.MeaningCellBackWordSynonymLabel.text = "Synonym : " + word.wordDef!
        self.MeaningCellBackWorDefinitionLabel.text = word.wordDef!
        
        
        //newline code
        //ESTranslateObject has new property name ESWordType
        self.MeaningCell_BackWordType.text = word.wordType
        self.MeaningCell_FrontWordTypeLabel.text = word.wordType
        
    }
 */
  override func awakeFromNib() {
    
    foregroundView.layer.cornerRadius = 10
    foregroundView.layer.masksToBounds = true
    
    super.awakeFromNib()
  }
  
  override func animationDuration(_ itemIndex:NSInteger, type:AnimationType)-> TimeInterval {
    
    let durations = [0.26, 0.2, 0.2]
    return durations[itemIndex]
  }
}

// MARK: Actions
extension MeaningCell {
  
  @IBAction func buttonHandler(_ sender: AnyObject) {
    print("tap")
    
    /*
    ESWordCoreDataAPI.sharedInstance.saveIntoCoreData(wordObj: self.currentExploringWordObj!) { (result) in
        let alertView = SCLAlertView()

        if (result)
        {
            alertView.showSuccess("Sucessfully Saved", subTitle: "Get ready to learn this word later on")

            
        }
        else
        {
            alertView.showSuccess("Sucessfully Saved", subTitle: "Get ready to learn this word later on")
            alertView.showError("Error", subTitle: "Fail to save this word, try  again later")
            
  
        }
        
    }
 */
    }
}
