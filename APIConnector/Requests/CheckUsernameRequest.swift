//
//  CheckUsernameRequest.swift
//  APIConnector
//
//  Created by Marwan Aziz on 04/06/2020.
//  Copyright © 2020 Marwan Aziz. All rights reserved.
//

import Foundation
import Alamofire

struct CheckUsernameRequest {
    let username: String

    init(username: String) {
        self.username = username
    }

    fileprivate var parameters: [String : Any] {
        return [
            "username": self.username,
            "action": APIManager.RequestAction.checkUsername.rawValue
        ]
    }

    func request() -> DataRequest {
        return AF.request(APIManager.endPoint, parameters:parameters).validate(contentType: ["application/json"])
    }
}
