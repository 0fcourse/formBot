//
//  RegistrationViewControllerViewModel.swift
//  FromBot
//
//  Created by Marwan Aziz on 10/06/2020.
//  Copyright © 2020 Marwan Aziz. All rights reserved.
//

import Foundation
import DataConnector

struct RegistrationViewModel {

    let conversationManager: RegistrationBot
    public let userInteractionEnabled: ObservableValue<Bool> = ObservableValue(true)
    public let updateInput: ObservableValue<(InputType, QuestionType)> = ObservableValue((.unknownInput, .unknown))
    public let registrationCompleted: ObservableValue<Bool> = ObservableValue(false)

    public var conversationCount: Int {
        return conversationManager.chatInputDataSourceCount
    }

    public var conversationDataSource: [BotInputObject] {
        return conversationManager.chatInputDataSource
    }

    public func userInput(input: String) {
        conversationManager.userInput = input
    }

    public var viewPickerDataSource: [String] {
        return conversationManager.pickerViewDataSource
    }

    public var selectedCountryCode: String? {
        return conversationManager.countryCode
    }

    public func postComment(_ comment: String) {
        conversationManager.postComment(comment: comment, delayTime: 500)
    }

    public func pickingCityCanceled() {
        conversationManager.searchForCityCanceled()
    }

    init() {
        conversationManager = RegistrationBot()
        bindConversationManager()
    }

    func bindConversationManager() {
        conversationManager.allowUserInteraction.bind { allow in
            self.userInteractionEnabled.value = allow
        }

        conversationManager.newChatInputTypeChanged.bind { inputType, questionType in
            self.updateInput.value = (inputType, questionType)
        }

        self.conversationManager.registrationCompleted.bind { args in
            if args.0, let userInfo = args.1, let username = userInfo.username {
                DataConnector.shared.storeUser(userInfo)
                DataConnector.shared.localLogin(user: username)
                self.registrationCompleted.value = args.0
            }
        }
    }
}
