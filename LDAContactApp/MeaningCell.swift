//
//  DemoCell.swift
//  FoldingCell
//
//  Created by Alex K. on 25/12/15.
//  Copyright © 2015 Alex K. All rights reserved.
//

import UIKit
import Foundation
class classCell: FoldingCell {
   fileprivate var detailTappedCallBackAction:(()->Void)!


    @IBAction func MeaningCell_DefinitionSpeakButtonTapped(_ sender: Any) {
        
        
       // ESSpeakerHelper.sharedInstance.speak(speakingString: self.MeaningCellBackWorDefinitionLabel.text!)
    }
    
    @IBAction func MeaningCell_ExampleSpeakButtonTapped(_ sender: Any) {
      //    ESSpeakerHelper.sharedInstance.speak(speakingString: self.MeaningCellBackWordExampleLabel.text!)
    }
    @IBAction func MeaningCell_SynonymsSpeakButtonTapped(_ sender: Any) {
         // ESSpeakerHelper.sharedInstance.speak(speakingString: self.MeaningCellBackWordSynonymLabel.text!)
        
        
    }
    @IBOutlet weak var MeaningCell_FrontWordTypeLabel: UILabel!
    @IBOutlet weak var MeaningCell_FrontWordDefinitionLabel: UILabel!
    
    @IBOutlet weak var MeaningCell_BackWordrightLabel: UILabel!
    @IBOutlet weak var MeaningCell_BackWordType: UILabel!
    @IBOutlet weak var MeaningCellBackWorDefinitionLabel: UILabel!
    @IBOutlet weak var MeaningCellBackWordExampleLabel: UILabel!
    @IBOutlet weak var MeaningCellBackWordSynonymLabel: UILabel!
  static let sharedInstance = classCell()
  var number: Int = 0 {
    didSet {
     
    
    }
  }
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
extension classCell {
  
  @IBAction func buttonHandler(_ sender: AnyObject) {
    print("tap")
    self.detailTappedCallBackAction()
    
  }
    func registerDetailTappedCallBackAction(action:@escaping ()->Void)
    {
     self.detailTappedCallBackAction =  action
    }
    
    func setWithClassDataModel(classModel:LDACAClass)
    {
        Date(timeIntervalSince1970: classModel.classStartDay!).localTime
     
        self.MeaningCell_FrontWordTypeLabel.text = "Room " + classModel.classRoomCode!
        self.MeaningCell_FrontWordDefinitionLabel.text = classModel.className
        
        
        self.MeaningCellBackWorDefinitionLabel.text = classModel.className
        self.MeaningCellBackWordExampleLabel.text = String(describing: classModel.classWeekDuration!) + " Weeks"
        self.MeaningCellBackWordSynonymLabel.text =  Date(timeIntervalSince1970: classModel.classStartDay!).localTime
        
        
        
        self.MeaningCell_BackWordType.text = "Room " + classModel.classRoomCode!
        self.MeaningCell_BackWordrightLabel.text =   Date(timeIntervalSince1970: classModel.classStartDay!).returnDayInWeekWord()
    }
}
