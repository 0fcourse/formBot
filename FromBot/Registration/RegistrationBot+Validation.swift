//
//  RegistrationViewModel.swift
//  FromBot
//
//  Created by Marwan Aziz on 07/06/2020.
//  Copyright © 2020 Marwan Aziz. All rights reserved.
//

import Foundation

struct ValidationError {
    var error: Bool
    var errorMessage: String?
}

extension RegistrationBot {

    func isValidPassword(password: String?) -> ValidationError {
        var error = ValidationError(error: false, errorMessage: nil)
        if let thePassword = password {
            if thePassword.count < 6 {
                error.error = true
                error.errorMessage = LocalString.Reg.Error.passwordIncorrect
                return error
            } else if thePassword.hasEmoji() {
                error.error = true
                error.errorMessage = LocalString.Reg.Error.passwordIncorrect
                return error
            } else if !thePassword.isAlphanumeric {
                error.error = true
                error.errorMessage = LocalString.Reg.Error.passwordIncorrect
                return error
            }
        } else {
            error.error = true
            error.errorMessage = LocalString.Reg.Error.passwordIncorrect
            return error
        }
        return error
    }

    func isValidUsername(username: String?) -> ValidationError {
        let username = username?.replacingOccurrences(of: "_", with: "")
        var error = ValidationError(error: false, errorMessage: nil)
        if let theUsername = username {
            if theUsername.count < 4 {
                error.error = true
                error.errorMessage = LocalString.Reg.Error.usernameGeneral
            } else if theUsername.hasEmoji() {
                error.error = true
                error.errorMessage = LocalString.Reg.Error.usernameContainsEmoji
            } else if !theUsername.isAlphanumeric {
                error.error = true
                error.errorMessage = LocalString.Reg.Error.usernameGeneral
            } else if let firstChar = theUsername.first {
                if !"\(firstChar)".isAlphabet {
                    error.error = true
                    error.errorMessage = LocalString.Reg.Error.usernameGeneral
                }
            }
        } else {
            error.error = true
            error.errorMessage = LocalString.Reg.Error.usernameGeneral
        }
        return error
    }

    func isValidNickname(nickname: String?) -> ValidationError {
        var error = ValidationError(error: false, errorMessage: nil)
        if let theNickname = nickname {
            if theNickname.count < 2 {
                error.error = true
                error.errorMessage = LocalString.Reg.Error.nicknameGeneral
            } else if theNickname.hasEmoji() {
                error.error = true
                error.errorMessage = LocalString.Reg.Error.nicknameEmoji
            } else if !theNickname.isAlphabet {
                error.error = true
                error.errorMessage = LocalString.Reg.Error.nicknameGeneral
            }
        } else {
            error.error = true
            error.errorMessage = LocalString.Reg.Error.nicknameGeneral
        }
        return error
    }

    func isValidEmail(email: String?) -> ValidationError {
        var error = ValidationError(error: false, errorMessage: nil)
        if let theEmail = email {
            if !isEmailValid(email: theEmail) {
                error.error = true
                error.errorMessage = LocalString.Reg.Error.emailGeneral
            }
        } else {
            error.error = true
            error.errorMessage = LocalString.Reg.Message.completedAnswers
        }
        return error
    }

    private func isEmailValid(email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }

    func isValidCityName(_ name: String) -> Bool {
        let cityName = name.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "")

        if cityName.isEmpty
            || cityName.hasEmoji()
            || cityName.count < 3
            || !cityName.isAlphabet {

            return false
        }

        return true
    }
}
