//
//  DataConnector.swift
//  DataConnector
//
//  Created by Marwan Aziz on 04/06/2020.
//  Copyright © 2020 Marwan Aziz. All rights reserved.
//

import APIConnector
import RealmConnector

public struct DataConnector: IDataConnector {

    fileprivate let apiConnector = APIConnector.shared
    fileprivate let realmConnector: IRealmConnector = RealmConnector.shared
    public static let shared: IDataConnector = DataConnector()

    public func isUsernameTaken(_ username: String, result: @escaping (Result<Bool, ConnectionError>) -> Void) {
        APIConnector.shared.isUsernameAvailable(username) { apiResult in
            switch apiResult {
            case .success(let available):
                result(.success(!available))
            case .failure:
                result(.failure(.connectionError))
            }
        }
    }

    public func isEmailAvailable(_ email: String, result: @escaping (Result<Bool, ConnectionError>) -> Void) {
        apiConnector.isEmailAvailable(email) { apiResult in
            switch apiResult {
            case .success(let available):
                result(.success(available))
            case .failure:
                result(.failure(.connectionError))
            }
        }
    }

    public func loginUser(username: String, password: String, result: @escaping (Result<UserInfoDataConnectorModel, ConnectionError>) -> Void) {

        apiConnector.login(username: username, password: password) { apiResult in

            switch apiResult {
            case .success(let userInfo):
                result(.success(self.convert(apiUserInfo: userInfo)))
            case .failure(let error):
                if error == .loginError {
                    result(.failure(.loginError))
                } else {
                    result(.failure(.connectionError))
                }
            }
        }
    }

    public func register(user: UserInfoDataConnectorModel, result: @escaping (Result<UserInfoDataConnectorModel, ConnectionError>) -> Void) {
        let newRegistrationInfo = convertToAPINewRegistration(dataConnectorUserInfo: user)
        apiConnector.registerNewUser(newRegistrationInfo) { apiResult in
            switch apiResult {
            case .success(let newRegistration):
                result(.success(self.convert(apiUserInfo: newRegistration)))
            case .failure:
                result(.failure(.connectionError))
            }
        }
    }

    public func isConnectedToInternet() -> Bool {
        return apiConnector.isConnectedToInternet()
    }

    public func getUser(_ username: String) -> UserInfoDataConnectorModel? {
        guard let userInfo = realmConnector.getUser(username) else { return nil }
        return convert(realmUserInfo: userInfo)
    }

    public func storeUser(_ user: UserInfoDataConnectorModel) {
        realmConnector.storeUser(convert(dataConnectorUserInfo: user))
    }

    public func localLogin(user username: String) {
        realmConnector.login(user: username)
    }

    public func getCurrentLoggedInUser() -> UserInfoDataConnectorModel? {
        guard let userInfo = realmConnector.getLoggedInUser() else {
            return nil
        }
        return convert(realmUserInfo: userInfo)
    }

    public func LogUserOut() {
        realmConnector.signUserOut()
    }

    fileprivate func convert(dataConnectorUserInfo userInfo: UserInfoDataConnectorModel) -> RealmUserInfoModel {
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(userInfo)
        return try! JSONDecoder().decode(RealmUserInfoModel.self, from: jsonData)
    }

    fileprivate func convert(realmUserInfo userInfo: RealmUserInfoModel) -> UserInfoDataConnectorModel {
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(userInfo)
        return try! JSONDecoder().decode(UserInfoDataConnectorModel.self, from: jsonData)
    }

    fileprivate func convert(newRegistrationInfo userInfo: NewRegistrationInfo) -> UserInfoDataConnectorModel {
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(userInfo)
        return try! JSONDecoder().decode(UserInfoDataConnectorModel.self, from: jsonData)
    }

    fileprivate func convertToAPINewRegistration(dataConnectorUserInfo userInfo: UserInfoDataConnectorModel ) -> NewRegistrationInfo {
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(userInfo)
        return try! JSONDecoder().decode(NewRegistrationInfo.self, from: jsonData)
    }

    fileprivate func convert(apiUserInfo userInfo: UserInfo ) -> UserInfoDataConnectorModel {
        var dataConnectorUserInfo = UserInfoDataConnectorModel()
        dataConnectorUserInfo.username = userInfo.username
        dataConnectorUserInfo.email = userInfo.email
        dataConnectorUserInfo.city = userInfo.city
        dataConnectorUserInfo.country = userInfo.country
        dataConnectorUserInfo.gender = userInfo.gender
        dataConnectorUserInfo.nickname = userInfo.nickname
        return dataConnectorUserInfo
    }
}
