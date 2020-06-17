//
//  IRealmConnector.swift
//  RealmConnector
//
//  Created by Marwan Aziz on 04/06/2020.
//  Copyright © 2020 Marwan Aziz. All rights reserved.
//

public protocol IRealmConnector {

    func storeUser(_ userInfo: RealmUserInfoModel)

    func getUser(_ username: String) -> RealmUserInfoModel?

    func login(user username: String)

    func getLoggedInUser() -> RealmUserInfoModel?

    func signUserOut()

}
