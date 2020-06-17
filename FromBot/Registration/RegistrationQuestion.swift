//
//  RegistrationQuestion.swift
//  FromBot
//
//  Created by Marwan Aziz on 07/06/2020.
//  Copyright © 2020 Marwan Aziz. All rights reserved.
//

import Foundation
import UIKit

enum QuestionType {
    case username
    case nickname
    case password
    case gender
    case yearOfBirth
    case city
    case country
    case email
    case conformation
    case editingOption
    case unknown
}

class RegistrationQuestion: BotInputObject {
    var question:String?
    var answer:String?

    var type:QuestionType? {
        didSet {
            updateQuestion(questionType: type!)
        }
    }

    func updateQuestion(questionType: QuestionType) {
        self.inputType = .basicQuestion
        switch questionType {
        case .username:
            self.question = LocalString.Reg.Question.usernameQuestion
        case .email:
            self.question = LocalString.Reg.Question.emailQuestion
        case .password:
            self.question = LocalString.Reg.Question.passwordQuestion
        case .nickname:
            self.question = LocalString.Reg.Question.nicknameQuestion
        case .gender:
            self.question = LocalString.Reg.Question.genderQuestion
        case .yearOfBirth:
            self.question = LocalString.Reg.Question.birthYearQuestion
        case .country:
            self.question = LocalString.Reg.Question.countryQuestion
        case .city:
            self.question = LocalString.Reg.Question.cityQuestion
        case .conformation:
            self.question = LocalString.Reg.Question.conformationAnswers
        case .editingOption:
            self.question = LocalString.Reg.Question.selectingToEditQuestion
        default:
//            fatalError("Error: Unknow question type!!")
            break
        }
    }
}
