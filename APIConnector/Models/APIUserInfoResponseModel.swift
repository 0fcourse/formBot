//
//  APILoginResponse.swift
//  APIConnector
//
//  Created by Marwan Aziz on 06/06/2020.
//  Copyright © 2020 Marwan Aziz. All rights reserved.
//

import Foundation

// MARK: - LoginResponse
struct APIUserInfoResponseModel: Codable {
    let errorMessage: String
    let response: Response

    enum CodingKeys: String, CodingKey {
        case errorMessage = "error_message"
        case response
    }
}

// MARK: - Response
struct Response: Codable {
    let userInfo: UserInfo
    let sessionID: String

    enum CodingKeys: String, CodingKey {
        case userInfo = "user_info"
        case sessionID = "session_id"
    }
}

// MARK: - UserInfo
public struct UserInfo: Codable {
    public let email, blocked, deleted, userID: String
    public let username, nickname, gender, lastSeen: String
    public let city, country: String
    public let yearOfBirth: JSONNull?

    enum CodingKeys: String, CodingKey {
        case email, blocked, deleted
        case userID = "user_id"
        case username, nickname, gender
        case lastSeen = "last_seen"
        case city, country
        case yearOfBirth = "year_of_birth"
    }
}

// MARK: - Encode/decode helpers

public class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(0)
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
