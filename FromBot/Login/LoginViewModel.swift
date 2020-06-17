//
//  LoginViewModel.swift
//  FromBot
//
//  Created by Marwan Aziz on 11/06/2020.
//  Copyright © 2020 Marwan Aziz. All rights reserved.
//

import Foundation
import DataConnector

struct LoginViewModel {

    var username: String?
    var password: String?
    let loginError: ObservableValue<String?> = ObservableValue(nil)
    let userLoggedIn: ObservableValue<Bool> = ObservableValue(false)

    func fieldStartEditing() {
        loginError.value = nil
    }

    func login() {
        guard let username = username, username.count > 3 else {
            loginError.value = LocalString.Login.Error.invalidLoginDetails
            return
        }

        if username.hasEmoji() {
            loginError.value = LocalString.Reg.Error.usernameContainsEmoji
            return
        }

        guard let password = password, password.trimmingCharacters(in: .whitespaces).count > 3  else {
            loginError.value = LocalString.Login.Error.invalidLoginDetails
            return
        }

        if password.hasEmoji() {
            loginError.value = LocalString.Login.Error.invalidLoginDetails
            return
        }

        DataConnector.shared.loginUser(username: username, password: password) { result in
            switch result {
            case .success(let userInfo):
                if let username = userInfo.username {
                    DataConnector.shared.storeUser(userInfo)
                    DataConnector.shared.localLogin(user: username)
                    self.userLoggedIn.value = true
                }
            case .failure(let error):
                if error == .loginError {
                    self.loginError.value = LocalString.Login.Error.invalidLoginDetails
                } else {
                    self.loginError.value = LocalString.Reg.Error.notConnected
                }
            }
        }
    }
}
