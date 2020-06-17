//
//  DateExtension.swift
//  jawaz
//
//  Created by Marwan Aziz on 06/08/2018.
//  Copyright © 2018 Marwan Aziz. All rights reserved.
//

import Foundation
extension NSDate {
    var currentYear:Int {
        return NSCalendar.current.component(.year, from: self as Date)
    }
}
