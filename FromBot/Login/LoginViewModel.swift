//
//  LoginViewModel.swift
//  FromBot
//
//  Created by Marwan Aziz on 11/06/2020.
//  Copyright © 2020 Marwan Aziz. All rights reserved.
//

import Foundation
import DataConnector

class LoginViewModel {

    fileprivate enum LoginDetailsErrorType {
        case invalidDetails
        case containEmoji
        case none
        case unknown
    }

    var dataConnector: IDataConnector { DataConnector.shared }
    var username: String?
    var password: String?
    let loginError: ObservableValue<String?> = ObservableValue(nil)
    let userLoggedIn: ObservableValue<Bool> = ObservableValue(false)

    func fieldStartEditing() {
        // The value of the login error will be triggered by the observer.
        loginError.value = nil
    }

    fileprivate func loginDetailsError() -> LoginDetailsErrorType {

        guard let username = username, username.count > 3 else {
            return .invalidDetails
        }

        if username.hasEmoji() {

            return .containEmoji
        }

        guard let password = password, password.trimmingCharacters(in: .whitespaces).count > 3  else {
            return .invalidDetails
        }

        if password.hasEmoji() {

            return .containEmoji
        }

        return .none
    }

    fileprivate func reportLoginError(withType type: LoginDetailsErrorType) {

        switch type {
        case .invalidDetails:
            reportError(LocalString.Login.Error.invalidLoginDetails)
        case .containEmoji:
            reportError(LocalString.Reg.Error.usernameContainsEmoji)
        default:
            reportError(LocalString.Login.Error.invalidLoginDetails)
        }
    }

    fileprivate func reportError(_ error: String) {
        // The value of the login error will be triggered by the observer
        loginError.value = error
    }

    fileprivate func storeLoginDetails(_ userInfo: UserInfoDataConnectorModel, username: String) {
        DataConnector.shared.storeUser(userInfo)
        DataConnector.shared.localLogin(user: username)
    }

    fileprivate func handleSuccessResponse(_ userInfo: UserInfoDataConnectorModel) {
        if let username = userInfo.username {
            self.storeLoginDetails(userInfo, username: username)
            self.userLoggedIn.value = true
        } else {
            reportError(LocalString.Login.Error.unableToLogin)
        }
    }

    fileprivate func handleFailureResponse(_ error: ConnectionError) {
        if error == .connectionError {
            self.reportError(LocalString.Reg.Error.notConnected)
        } else {
            self.reportError(LocalString.Login.Error.invalidLoginDetails)
        }
    }

    fileprivate func loginUser() {
        guard let username = username, let password = password else {
            return
        }

        dataConnector.loginUser(username: username, password: password) { [weak self] result in
            switch result {
            case .success(let userInfo):
                self?.handleSuccessResponse(userInfo)
            case .failure(let error):
                self?.handleFailureResponse(error)
            }
        }
    }

    func login() {

        let loginError = loginDetailsError()
        if loginError != .none {
            reportLoginError(withType: loginError)
        } else {
            loginUser()
        }
    }
}
