//
//  UserInfoDataConnectorModel.swift
//  DataConnector
//
//  Created by Marwan Aziz on 08/06/2020.
//  Copyright © 2020 Marwan Aziz. All rights reserved.
//

public struct UserInfoDataConnectorModel: Codable {
    public var email, password: String?
    public var username, nickname, gender: String?
    public var city, country: String?
    public var yearOfBirth: String?

    enum CodingKeys: String, CodingKey {
        case email, password
        case username, nickname, gender
        case city, country
        case yearOfBirth
    }
}
