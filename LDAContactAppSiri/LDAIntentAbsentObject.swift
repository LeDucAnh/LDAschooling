//
//  LDAIntentAbsentObject.swift
//  LDAContactApp
//
//  Created by Mac on 6/9/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit

class LDAIntentAbsentObject: NSObject {
    //i’m going to (miss | absent )  class acb on (10 october 2017 | tomorrow | Monday, Tuesday , …)
    
    static var shareInstance = LDAIntentAbsentObject()
    var absentIntentWord = ["miss","absent","lost"]
    var absentIntentTime : TimeInterval  = -1
    
    
    var negativeVocabulray  = ["not","n't"]
    var absentNegativeIntentWord = ["be","attend","join"]
    
    //------------
    private var absentIntentTimeDayWord = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Tomorrow"]
    
    
    lazy var absentDayInMonth:  [String] = {
        var DaysArr = [String]()
        
        var i = 1
        
        while i < 32
        {
            
            
            DaysArr.append(String(i))
            
            i += 1
        }
        
        
        return DaysArr
    }()
    lazy var absentMonthInYear:  [String] = {
        
        
        
        return ["January","February","March","April","May","June","July","August","September","October","November","December"]
    }()
    
    //-----------------------------
    
    
    var dayWord = ""
    var dayInMonthWord = ""
    var monthInYearWord = ""
    
    func returnDateFromCalendarWord()->Date
    {
        
        let currentdate = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: currentdate)
        
        
        var dayinString =  self.dayInMonthWord
        
        
        if absentDayInMonth.index(of: self.dayInMonthWord)! < 10
        {
            dayinString = "0" + self.dayInMonthWord
            
        }
        
        
        
        
        
        var dateString = "\(String(year))-\(absentMonthInYear.index(of: self.monthInYearWord))-\(dayinString)" // change to your date format
        
        
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        
        
        return  dateFormatter.date(from: dateString)!
        
        
    }
    func returnDateFromDayWord()->Date
    {
        var currentDateInterVal = Date().timeIntervalSince1970
        var returnDateInterVal  = -1.0
        if dayWord == "Tomorrow"
        {
            returnDateInterVal = currentDateInterVal + 86400
        }
        else
        {
            let calendar = Calendar.current
            
            let currentDay =   calendar.component(.weekday, from: Date())
            
            
            //return form 0 -> 7 stand for 7 days only not contains tomorrow
            
            let targetDay = self.absentIntentTimeDayWord.index(of: self.dayWord)
            
            if targetDay! <= currentDay
            {
                let i  = targetDay! +  7 - currentDay
                returnDateInterVal = currentDateInterVal + (86400.0 * Double(i))
                
            }
            else
            {
                let i  = targetDay! - currentDay
                returnDateInterVal = currentDateInterVal + (86400.0 * Double(i))
                
            }
            
        }
        
        
        return Date(timeIntervalSince1970: returnDateInterVal)
        
    }
    func returnDate()->Date
    {
        if dayWord == ""
        {
            
            if dayInMonthWord != "" && monthInYearWord != ""
            {
                return   returnDateFromCalendarWord()
                
            }
        }
        else
        {
            return self.returnDateFromDayWord()
            
        }
        
        return Date()
    }
    func composeDateToString()->String
    {
        let string = dayWord + dayInMonthWord + " " + monthInYearWord
        return string
    }
    
    func getIntentObjectFrom(intentString:String)-> (LDAIntentAbsentObject,Bool)
    {
        let bool =  self.checkAndGenerateSelfWith(intentString)
        
        
        return (self,bool)
    }
    func checkAndGenerateSelfWith(_ intentString:String)->Bool
    {
        //check intentWord
        var (NegativeWordBool,negativematchValue) = intentString.checkStringContainsOnlyItemInArrayString(arr: negativeVocabulray)
        
        
        var absentWords = absentIntentWord
        if NegativeWordBool ==  true{
            absentWords =  absentNegativeIntentWord
        }
        
        
        
        var (IntentWordBool,matchValue) = intentString.checkStringContainsOnlyItemInArrayString(arr: absentWords)
        
        
        if IntentWordBool == true  {
            //  var IntentDayBool = false
            //var check IntentDayBool
            
            let (absentIntentTimeDayWordBool,dayValue) = intentString.checkStringContainsOnlyItemInArrayString(arr: self.absentIntentTimeDayWord)
            
            self.dayWord = dayValue
            let (absentDayInMonthBool,daymonthValue) = intentString.checkStringContainsOnlyItemInArrayString(arr: self.absentDayInMonth)
            self.dayInMonthWord = daymonthValue
            
            let (absentMonthInYear,monthValue) = intentString.checkStringContainsOnlyItemInArrayString(arr: self.absentMonthInYear)
            self.monthInYearWord = monthValue
            
            
            
            
            if absentIntentTimeDayWordBool == true &&  absentDayInMonthBool == false &&    absentMonthInYear ==  false{
                
                
                return true
            }
            if absentIntentTimeDayWordBool == false &&  absentDayInMonthBool == true &&    absentMonthInYear ==  true{
                
                
                return true
                
            }
            
        }
        
        
        
        return false
        
    }
    
    
    
}

extension String
{
    func checkStringContainsOnlyItemInArrayString(arr :[String])-> (Bool,String)
    {
        
        var bool = false
        
        var matchValue = ""
        
        
        
        
        let sourceString = self.lowercased().replacingOccurrences(of: "\n", with: "")
        for item in arr
        {
            let compareString = item.lowercased().replacingOccurrences(of: "\n", with: "")
            
            //     if self.lowercased().contains(item.lowercased())
            if sourceString.contains(compareString)
                
            {
                
                if bool == false
                {
                    bool =  true
                    matchValue =  item
                }
                else{
                    return (false,"")
                }
            }
            
            
        }
        
        return (bool,matchValue)
    }
}
