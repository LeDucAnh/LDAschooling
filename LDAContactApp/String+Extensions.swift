//
//  String+Extensions.swift
//  LDAContactApp
//
//  Created by Mac on 5/16/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit
extension NSRange {
    func range(for str: String) -> Range<String.Index>? {
        guard location != NSNotFound else { return nil }
        
        guard let fromUTFIndex = str.utf16.index(str.utf16.startIndex, offsetBy: location, limitedBy: str.utf16.endIndex) else { return nil }
        guard let toUTFIndex = str.utf16.index(fromUTFIndex, offsetBy: length, limitedBy: str.utf16.endIndex) else { return nil }
        guard let fromIndex = String.Index(fromUTFIndex, within: str) else { return nil }
        guard let toIndex = String.Index(toUTFIndex, within: str) else { return nil }
        
        return fromIndex ..< toIndex
    }
}


//MARK STRINGEXTENSION

extension String {
            func removeWhitespace() -> String {
            return self.trimmingCharacters(in: .whitespaces)
        }
        func removelinesWithNoText()->String{
            return self.replacingOccurrences(of: "\n\n", with: "")
        }
    
    

    func elimateStringinSet(arr:[String])->String
    {
        var string  =  self
        
        for item in arr
        {
            string = string.replacingOccurrences(of: item, with: "")
        }
        return string
    }
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.width
    }
    
    
    
    
}

