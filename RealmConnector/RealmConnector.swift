//
//  RealmConnector.swift
//  RealmConnector
//
//  Created by Marwan Aziz on 04/06/2020.
//  Copyright © 2020 Marwan Aziz. All rights reserved.
//
import RealmSwift

public struct RealmConnector: IRealmConnector {

    public static let shared: IRealmConnector = RealmConnector()
    var realm: Realm? {

        do {
            let realm = try Realm()
            print(Realm.Configuration.defaultConfiguration.fileURL!)
            return realm
        } catch {
            return nil
        }
    }

    public func storeUser(_ userInfo: RealmUserInfoModel) {
        guard getUser(userInfo.username!) == nil  else { return }
        let newUser = RealmUserInfo()
        newUser.appendModel(model: userInfo)

        try! realm?.write {
            realm?.add(newUser)
        }
    }

    public func getUser(_ username: String) -> RealmUserInfoModel? {
        guard let userObject = realm?.objects(RealmUserInfo.self).filter("username = %@", username).first else {
            return nil
        }
        let userInfo = RealmUserInfoModel(fromRealmObject: userObject)
        return userInfo
    }

    public func login(user username: String) {
        let loggedInUser = realm?.objects(RealmUserInfo.self).filter({$0.loggedIn == true}).first
        if let loggedInUser = loggedInUser, loggedInUser.username == username {
            return
        }

        guard let userObject = realm?.objects(RealmUserInfo.self).filter("username = %@", username).first else {
            return
        }

        try! realm?.write {
            userObject.loggedIn = true
            loggedInUser?.loggedIn = false
        }
    }

    public func getLoggedInUser() -> RealmUserInfoModel? {
        guard let loggedInUser = realm?.objects(RealmUserInfo.self).filter({$0.loggedIn == true}).first else {
            return nil
        }
        let userInfo = RealmUserInfoModel(fromRealmObject: loggedInUser)
        return userInfo
    }

    public func signUserOut() {
        guard let loggedInUser = realm?.objects(RealmUserInfo.self).filter({$0.loggedIn == true}).first else {
            return
        }
        try! realm?.write {
            loggedInUser.loggedIn = false
        }
    }
}
