//
//  RealmUserInfo.swift
//  RealmConnector
//
//  Created by Marwan Aziz on 11/06/2020.
//  Copyright © 2020 Marwan Aziz. All rights reserved.
//

import Foundation
import RealmSwift

class RealmUserInfo: Object {

    @objc dynamic var email: String = ""
    @objc dynamic var username: String = ""
    @objc dynamic var nickname: String = ""
    @objc dynamic var gender: String = ""
    @objc dynamic var city: String = ""
    @objc dynamic var country: String = ""
    @objc dynamic var yearOfBirth: String = ""
    @objc dynamic var loggedIn: Bool = false

    override class func primaryKey() -> String? {
        return "username"
    }

    func appendModel(model: RealmUserInfoModel) {
        self.username = model.username ?? ""
        self.email = model.email ?? ""
        self.city = model.city ?? ""
        self.country = model.country ?? ""
        self.nickname = model.nickname ?? ""
        self.gender = model.gender ?? ""
        self.yearOfBirth = model.yearOfBirth ?? ""
    }
}
