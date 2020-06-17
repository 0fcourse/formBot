//
//  APIConnector.swift
//  APIConnector
//
//  Created by Marwan Aziz on 04/06/2020.
//  Copyright © 2020 Marwan Aziz. All rights reserved.
//

import Foundation
import Alamofire

public struct APIConnector: IAPIConnector {

    public static let shared: IAPIConnector = APIConnector()

    public func isUsernameAvailable(_ username: String, result: @escaping (Result<Bool, NetworkError>) -> Void) {
        let checkUsernameRequest = CheckUsernameRequest(username: username)
        checkUsernameRequest.request().validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let jsonResponse = response.value as? [String : Any], let errorMessage = jsonResponse["error_message"] as? String else {
                        result(.success(true))
                        return
                    }
                    result(.success(errorMessage.isEmpty))
                case .failure:
                    result(.failure(.connectionError))
                }
        }
    }

    public func isEmailAvailable(_ email: String, result: @escaping (Result<Bool, NetworkError>) -> Void) {
        let checkEmail = CheckEmailRequest(email: email)
        checkEmail.request()
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let jsonResponse = response.value as? [String : Any], let errorMessage = jsonResponse["error_message"] as? String else {
                        result(.failure(.connectionError))
                        return
                    }
                    result(.success(errorMessage.isEmpty))
                case .failure:
                    result(.failure(.connectionError))
                }
        }
    }

    public func login(username: String, password: String, result: @escaping (Result<UserInfo, NetworkError>) -> Void) {
        let loginRequest = LoginRequest(username: username, password: password)
        loginRequest.request()
            .validate(statusCode: 200..<300)
            .responseDecodable(of: APIUserInfoResponseModel.self) { response in
                switch response.result {
                case .success(let anyResponse):
                    if anyResponse.errorMessage.isEmpty {
                        result(.success(anyResponse.response.userInfo))
                    } else {
                        result(.failure(.loginError))
                    }

                case .failure:
                    result(.failure(.connectionError))
                }
        }
    }

    public func registerNewUser(_ newUser: NewRegistrationInfo, result: @escaping (Result<UserInfo, NetworkError>) -> Void) {
        let registerRequest = RegisterRequest(newUser: newUser)
        registerRequest.request()
            .validate(statusCode: 200..<300)
            .responseDecodable(of: APIUserInfoResponseModel.self) { response in
                    switch response.result {
                    case .success(let anyResponse):
                        result(.success(anyResponse.response.userInfo))
                    case .failure:
                        result(.failure(.connectionError))
                    }
            }
    }

    public func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
