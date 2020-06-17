//
//  APIManager.swift
//  APIConnector
//
//  Created by Marwan Aziz on 04/06/2020.
//  Copyright © 2020 Marwan Aziz. All rights reserved.
//
import Foundation
import Alamofire

struct APIManager {

    static let endPoint = "https://marwanaziz.net/APIs/formdata/main.php"
    static let deviceID = UIDevice.current.identifierForVendor!.uuidString

    enum RequestAction: String {
        case checkUsername = "CheckUsername"
        case checkEmail = "CheckEmail"
        case newUser = "NewUser"
        case userLogin = "UserLogin"
        case getUserDetails = "GetUserDetails"
    }
}
