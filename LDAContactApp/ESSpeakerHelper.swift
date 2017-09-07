//
//  ESSpeakerHelper.swift
//  HSUFreeWalkingtour
//
//  Created by Mac on 2/22/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit
import AVFoundation
class ESSpeakerHelper: NSObject {
    let speechSynthesizer = AVSpeechSynthesizer()
    
    //this value is singleton design pattern to access method in ESSpeakerHelper
    static let sharedInstance = ESSpeakerHelper()
    func speak(speakingString:String)
    {
     //create AVSpeechUtterance object
        
        let speechUtterance = AVSpeechUtterance(string:speakingString)
      //speed of speech
        speechUtterance.rate = 0.45
        
        ///pitchMultiplier: The pitch multiplier acceptable values are between 0.5 and 2.0, where 1.0 is the default valu
        //pitch value
        speechUtterance.pitchMultiplier = 1.0

        //start speaking
        if   !speechSynthesizer.isSpeaking
        {
        speechSynthesizer.speak(speechUtterance)
        }
        else
        {
            speechSynthesizer.stopSpeaking(at: .word)
        }

        
    }
}
