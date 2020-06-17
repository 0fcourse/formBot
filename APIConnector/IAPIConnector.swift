//
//  IAPIConnector.swift
//  APIConnector
//
//  Created by Marwan Aziz on 04/06/2020.
//  Copyright © 2020 Marwan Aziz. All rights reserved.
//

public enum NetworkError: Error {
    case connectionError
    case serializationError
    case loginError
}

public protocol IAPIConnector {

    func isUsernameAvailable(_ username: String,  result: @escaping ( Result<Bool, NetworkError>) -> Void)

    func isEmailAvailable(_ email: String,  result: @escaping ( Result<Bool, NetworkError>) -> Void)

    func login(username: String, password: String,  result: @escaping ( Result<UserInfo, NetworkError>) -> Void)

    func isConnectedToInternet() -> Bool

    func registerNewUser(_ newUser: NewRegistrationInfo, result: @escaping (Result<UserInfo, NetworkError>) -> Void)
}
