//
//  CheckEmailRequest.swift
//  APIConnector
//
//  Created by Marwan Aziz on 06/06/2020.
//  Copyright © 2020 Marwan Aziz. All rights reserved.
//

import Foundation
import Alamofire

struct CheckEmailRequest {
    let email: String

    init(email: String) {
        self.email = email
    }

    fileprivate var parameters: [String : Any] {
        return [
            "email": self.email,
            "action": APIManager.RequestAction.checkEmail.rawValue
        ]
    }

    func request() -> DataRequest {
        return AF.request(APIManager.endPoint, parameters:parameters).validate(contentType: ["application/json"])
    }
}
