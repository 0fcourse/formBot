//
//  TestLoginViewModel.swift
//  FromBotTests
//
//  Created by Marwan Aziz on 18/06/2020.
//  Copyright © 2020 Marwan Aziz. All rights reserved.
//

import XCTest
@testable import FromBot

class TestLoginViewModel: XCTestCase {

    var error: String?
    var loginViewModel: LoginViewModel?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        loginViewModel = LoginViewModel()
        loginViewModel?.loginError.bind { loginError in
            self.error = loginError
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        loginViewModel = nil
    }

    func testLoginShortUsername() throws {
        loginViewModel?.username = "nkl"
        loginViewModel?.password = "00000"
        loginViewModel?.login()
        sleep(1)
        XCTAssertEqual(error, "Invalid login details, please check your username and password and try again!")
    }

    func testLoginUsernameContainsEmojis() throws {
        loginViewModel?.username = "nkl🌝"
        loginViewModel?.password = "00000"
        loginViewModel?.login()
        sleep(1)
        XCTAssertEqual(error, "We love ❤️ emojis too, but currently nickname can't contain emojis\nPlease try different one!")
    }

    func testLoginShortPassword() throws {
        loginViewModel?.username = "nkll"
        loginViewModel?.password = "000"
        loginViewModel?.login()
        sleep(1)
        XCTAssertEqual(error, "Invalid login details, please check your username and password and try again!")
    }

    func testLoginPasswordContainsEmojis() throws {
        loginViewModel?.username = "nklf"
        loginViewModel?.password = "00000🌝"
        loginViewModel?.login()
        sleep(1)
        XCTAssertEqual(error, "Invalid login details, please check your username and password and try again!")
    }

    func testLoginConnectionError() throws {
        loginViewModel = MockedLoginViewModel()
        loginViewModel?.loginError.bind { loginError in
            self.error = loginError
        }
        loginViewModel?.username = "nklf"
        loginViewModel?.password = "0000000000"
        loginViewModel?.login()
        sleep(1)
        XCTAssertEqual(error, "Please make sure you have Internet connection to continue the registration.")
    }
}
