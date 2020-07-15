//
//  MockedDataConnector.swift
//  FromBotTests
//
//  Created by Marwan Aziz on 18/06/2020.
//  Copyright © 2020 Marwan Aziz. All rights reserved.
//

import Foundation
import DataConnector

struct MockedDataConnector: IDataConnector {

    static public let shared: IDataConnector = MockedDataConnector()

    func isUsernameTaken(_ username: String, result: @escaping (Result<Bool, ConnectionError>) -> Void) {

    }

    func isEmailAvailable(_ email: String, result: @escaping (Result<Bool, ConnectionError>) -> Void) {

    }

    func loginUser(username: String, password: String, result: @escaping (Result<UserInfoDataConnectorModel, ConnectionError>) -> Void) {
        result(.failure(.connectionError))
    }

    func register(user: UserInfoDataConnectorModel, result: @escaping (Result<UserInfoDataConnectorModel, ConnectionError>) -> Void) {

    }

    func isConnectedToInternet() -> Bool {
        false
    }

    func getUser(_ username: String) -> UserInfoDataConnectorModel? {
        nil
    }

    func storeUser(_ user: UserInfoDataConnectorModel) {

    }

    func localLogin(user username: String) {

    }

    func LogUserOut() {

    }

    func getCurrentLoggedInUser() -> UserInfoDataConnectorModel? {
        nil
    }
}
