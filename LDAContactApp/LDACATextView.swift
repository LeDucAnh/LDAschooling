//
//  LDACATextView.swift
//  LDAContactApp
//
//  Created by Mac on 7/6/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit



class LDACATextView:UITextView,UITextViewDelegate
{
    
    var LDACATextViewDelegate : UITextViewDelegate!
    var placeHolder: String = ""
    {
        didSet
        {
            self.setup()
        }
    }
    
    func setup()
    {
        self.delegate =  self
        self.text = self.placeHolder
        self.textColor = UIColor.lightGray
        
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
        }
        
        if self.LDACATextViewDelegate  != nil
        {
            self.LDACATextViewDelegate.textViewDidBeginEditing!(self)
        }
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = UIColor.lightGray
            textView.text = "Placeholder"
            
        }else
        {
            textView.textColor = UIColor.black
        }
        if self.LDACATextViewDelegate != nil
        {
            
            self.LDACATextViewDelegate.textViewDidEndEditing!(self)
        }
        
    }
}

