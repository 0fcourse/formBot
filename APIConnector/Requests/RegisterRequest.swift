//
//  RegisterRequest.swift
//  APIConnector
//
//  Created by Marwan Aziz on 08/06/2020.
//  Copyright © 2020 Marwan Aziz. All rights reserved.
//

import Alamofire

struct RegisterRequest {

    let newUser: NewRegistrationInfo

    init(newUser: NewRegistrationInfo) {
        self.newUser = newUser
    }

    fileprivate var parameters: [String : Any] {
        return [
            "username": newUser.username ?? "",
            "password": newUser.password ?? "",
            "email": newUser.email ?? "",
            "gender": newUser.gender ?? "",
            "city": newUser.city ?? "",
            "country": newUser.country ?? "",
            "nickname": newUser.nickname ?? "",
            "year_of_birth": newUser.yearOfBirth ?? "",
            "device_id": APIManager.deviceID,
            "language_code": "en",
            "action": APIManager.RequestAction.newUser.rawValue
        ]
    }

    func request() -> DataRequest {
        return AF.request(APIManager.endPoint, parameters:parameters).validate(contentType: ["application/json"])
    }
}
