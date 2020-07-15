//
//  MockedLoginViewModel.swift
//  FromBotTests
//
//  Created by Marwan Aziz on 18/06/2020.
//  Copyright © 2020 Marwan Aziz. All rights reserved.
//

import Foundation
@testable import FromBot
@testable import DataConnector

class MockedLoginViewModel: LoginViewModel {
    override var dataConnector: IDataConnector { MockedDataConnector.shared }
}
