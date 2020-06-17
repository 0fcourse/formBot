//
//  NewRegistrationInfo.swift
//  APIConnector
//
//  Created by Marwan Aziz on 08/06/2020.
//  Copyright © 2020 Marwan Aziz. All rights reserved.
//

import Foundation

public struct NewRegistrationInfo: Codable {
    var email, password: String?
    var username, nickname, gender: String?
    var city, country: String?
    var yearOfBirth: String?

    enum CodingKeys: String, CodingKey {
        case email, password
        case username, nickname, gender
        case city, country
        case yearOfBirth
    }

    init() {}
}
