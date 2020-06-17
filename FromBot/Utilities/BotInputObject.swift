//
//  BotInputObject.swift
//  FromBot
//
//  Created by Marwan Aziz on 07/06/2020.
//  Copyright © 2020 Marwan Aziz. All rights reserved.
//

import Foundation

enum InputType {
    case unknownInput
    case basicQuestion
    case questionAnswer
    case datePickerQuestion
    case dataPickerQuestion
    case comment
    case commentWithImage
}

class BotInputObject {
    var index = 0
    var text:String?
    var imageName: String?
    var userInput:Bool = false
    var inputType:InputType = .unknownInput
}
