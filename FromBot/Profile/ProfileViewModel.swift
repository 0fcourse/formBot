//
//  ProfileViewModel.swift
//  FromBot
//
//  Created by Marwan Aziz on 12/06/2020.
//  Copyright © 2020 Marwan Aziz. All rights reserved.
//

import Foundation
import DataConnector

struct ProfileViewModel {

    let greetingMessage: ObservableValue<String?> = ObservableValue(nil)
    let nickname: ObservableValue<String?> = ObservableValue(nil)
    let username: ObservableValue<String?> = ObservableValue(nil)
    let email: ObservableValue<String?> = ObservableValue(nil)
    let gender: ObservableValue<String?> = ObservableValue(nil)
    let city: ObservableValue<String?> = ObservableValue(nil)
    let country: ObservableValue<String?> = ObservableValue(nil)
    let noLoggedInUserFound: ObservableValue<Bool> = ObservableValue(false)

    init() {
        guard let userInfo = DataConnector.shared.getCurrentLoggedInUser() else {
            noLoggedInUserFound.value = true
            return
        }

        greetingMessage.value = LocalString.Profile.greetingMessage
        nickname.value = userInfo.nickname
        username.value = userInfo.username
        email.value = userInfo.email
        city.value = userInfo.city
        country.value = userInfo.country
        if let gender = userInfo.gender {
            if gender.lowercased() == "o" {
                self.gender.value = LocalString.Reg.other
            } else if gender.lowercased() == "f" {
                self.gender.value = LocalString.Reg.female
            } else {
                self.gender.value = LocalString.Reg.male
            }
        }
    }

    func signOut() {
        DataConnector.shared.LogUserOut()
    }
}
