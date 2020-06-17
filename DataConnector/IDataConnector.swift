//
//  IDataConnector.swift
//  DataConnector
//
//  Created by Marwan Aziz on 04/06/2020.
//  Copyright © 2020 Marwan Aziz. All rights reserved.
//

public enum ConnectionError: Error {
    case connectionError
    case loginError
}

public protocol IDataConnector {

    func isUsernameTaken(_ username: String, result: @escaping (Result<Bool, ConnectionError>) -> Void)

    func isEmailAvailable(_ email: String, result: @escaping (Result<Bool, ConnectionError>) -> Void)

    func loginUser(username: String, password: String, result: @escaping (Result<UserInfoDataConnectorModel, ConnectionError>) -> Void)

    func register(user: UserInfoDataConnectorModel, result: @escaping (Result<UserInfoDataConnectorModel, ConnectionError>) -> Void)

    func isConnectedToInternet() -> Bool

    func getUser(_ username: String) -> UserInfoDataConnectorModel?

    func storeUser(_ user: UserInfoDataConnectorModel)

    func localLogin(user username: String)

    func LogUserOut()

    func getCurrentLoggedInUser() -> UserInfoDataConnectorModel?
}
