//
//  LoginRequest.swift
//  APIConnector
//
//  Created by Marwan Aziz on 06/06/2020.
//  Copyright © 2020 Marwan Aziz. All rights reserved.
//

import Foundation
import Alamofire

struct LoginRequest {
    let username: String
    let password: String

    init(username: String, password: String) {
        self.username = username
        self.password = password
    }

    fileprivate var parameters: [String : Any] {
        return [
            "username": self.username,
            "password": self.password,
            "device_id": APIManager.deviceID,
            "language_code": "en",
            "action": APIManager.RequestAction.userLogin.rawValue
        ]
    }

    func request() -> DataRequest {
        return AF.request(APIManager.endPoint, parameters:parameters).validate(contentType: ["application/json"])
    }
}
