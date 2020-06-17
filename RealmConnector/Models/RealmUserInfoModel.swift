//
//  RealmUserInfoModel.swift
//  RealmConnector
//
//  Created by Marwan Aziz on 11/06/2020.
//  Copyright © 2020 Marwan Aziz. All rights reserved.
//

import Foundation

public struct RealmUserInfoModel: Codable {
    var email: String?
    var username, nickname, gender: String?
    var city, country: String?
    var yearOfBirth: String?

    enum CodingKeys: String, CodingKey {
        case email
        case username, nickname, gender
        case city, country
        case yearOfBirth
    }

    init() {}

    init(fromRealmObject userObject: RealmUserInfo) {
        self.username = userObject.username
        self.email = userObject.email
        self.city = userObject.city
        self.country = userObject.country
        self.nickname = userObject.nickname
        self.gender = userObject.gender
        self.yearOfBirth = userObject.yearOfBirth
    }
}
