//
//  Date.swift
//  TwitterFirebase
//
//  Created by Abhishesh Pradhan on 30/4/18.
//  Copyright © 2018 Abhishesh Pradhan. All rights reserved.
//

import Foundation

extension Date {
    
    
    public func timePassed() -> String {
        let date = Date()
        let calendar = Calendar.autoupdatingCurrent
        let components = (calendar as NSCalendar).components([.year, .month, .day, .hour, .minute, .second], from: self, to: date, options: [])
        var str: String
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd/MM/yy"
        
        if components.day! >= 7 {
            return "\(inputFormatter.string(from: date)) "
        } else if components.day! >= 1 {
            components.day == 1 ? (str = "d") : (str = "d")
            return "\(components.day!)\(str) "
        } else if components.hour! >= 1 {
            components.hour == 1 ? (str = "h") : (str = "h")
            return "\(components.hour!)\(str) "
        } else if components.minute! >= 1 {
            components.minute == 1 ? (str = "m") : (str = "m")
            return "\(components.minute!)\(str) "
        } else if components.second! >= 1 {
            components.second == 1 ? (str = "s") : (str = "s")
            return "\(components.second!)\(str)"
        } else {
            return "Just now"
        }
    }
}
