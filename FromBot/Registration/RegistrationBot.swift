//
//  RegistrationBot.swift
//  FromBot
//
//  Created by Marwan Aziz on 07/06/2020.
//  Copyright © 2020 Marwan Aziz. All rights reserved.
//

import Foundation
import DataConnector

private let dataConnector = DataConnector.shared

class RegistrationBot {

    fileprivate var userInfo: RegistrationInfoModel = RegistrationInfoModel()
    var allowUserInteraction:ObservableValue<Bool> = ObservableValue(true)
    var chatInputDataSource: [BotInputObject] = []
    var pickerViewDataSource :[String] = []
    private var currentQuestionType:QuestionType = .unknown
    var registrationCompleted:ObservableValue<(Bool, UserInfoDataConnectorModel?)> = ObservableValue((false, nil))
    private let oneSecond = 1000
    private var editingQuestionMode = false
    var newChatInputTypeChanged:ObservableValue<(inputType:InputType, questionType:QuestionType)> = ObservableValue((inputType:.unknownInput, questionType:.unknown))

    private var listOfCountries: [String] {
        let locale = NSLocale.current
        let countryArray = NSLocale.isoCountryCodes
        var unsortedCountryArray:[String] = []
        for countryCode in countryArray {
            let displayNameString = locale.localizedString(forRegionCode: countryCode)
            if displayNameString != nil {
                unsortedCountryArray.append(displayNameString!)
            }
        }

        var sortedCountryArray = unsortedCountryArray.sorted { $0 < $1 }
        sortedCountryArray.insert("", at: 0)
        return sortedCountryArray
    }

    fileprivate let conformationOptions = ["",LocalString.Reg.yes, LocalString.Reg.no]
    fileprivate let editingOptions = ["",
                                      LocalString.Reg.username,
                                      LocalString.Reg.email,
                                      LocalString.Reg.password,
                                      LocalString.Reg.nickname,
                                      LocalString.Reg.yearOfBirth,
                                      LocalString.Reg.gender,
                                      LocalString.Reg.country,
                                      LocalString.Reg.city,
                                      LocalString.Reg.cancel]
    var userInput: String? {
        didSet {
            self.chatUserInput(text: userInput ?? "")
        }
    }

    var chatInputDataSourceCount: Int {
        return self.chatInputDataSource.count
    }

    var pickerViewDataSourceCount: Int {
        return self.pickerViewDataSource.count
    }

    private var ageYear : [String] {
        let thisYear = NSDate().currentYear - 18
        var array = [String]()
        array.append("")
        for index in 0...100 {
            let year = "\(thisYear - index)"
            array.append(year)
        }
        return array
    }

    private let genders = ["", LocalString.Reg.female, LocalString.Reg.male, LocalString.Reg.other]
    var countryCode:String?
    init() {
        self.allowUserInteraction.value = true
        userInput = nil
        countryCode = ""
        postComment(comment: LocalString.Reg.greetingMessage, delayTime: 0)
        //Wait 2 seconds after the greeting and send the question
        DispatchQueue.main.asyncAfter(deadline:.now() + .milliseconds(self.oneSecond) , execute: {[weak self] in
            self?.askForUsername()
        })
    }

    func askForUsername() {
        self.currentQuestionType = .username
        self.postQuestion(delayTime: 0, questionType: .username)
    }

    func postQuestion(delayTime: Int, questionType: QuestionType) {
        self.currentQuestionType = questionType
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delayTime), execute: {[weak self] in
            let newQuestion  = RegistrationQuestion()
            newQuestion.type = questionType
            self?.chatInputDataSource.append(newQuestion)
            self?.newChatInputTypeChanged.value = (.basicQuestion, questionType)
        })
    }

    func postComment(comment: String, delayTime: Int, withImageName imageName: String? = nil, commentType: InputType = .comment) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delayTime), execute: {[weak self] in
            let theComment  = BotInputObject()
            theComment.text = comment
            theComment.inputType = commentType
            theComment.imageName = imageName
            self?.chatInputDataSource.append(theComment)
            self?.newChatInputTypeChanged.value = (.comment, .unknown)
        })
    }

    func postUserAnswer(answer: String) {
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {[weak self] in
            let comment  = BotInputObject()
            comment.inputType = .questionAnswer
            comment.text = answer
            self?.chatInputDataSource.append(comment)
            self?.newChatInputTypeChanged.value = (.comment, .unknown)
        })
    }

    func searchForCityCanceled() {
        postComment(comment: LocalString.Reg.Message.citySearchCanceled, delayTime: oneSecond/2)
    }

    func askConformationQuestionAfterDelay(delay: Int, postAllAnswersFirst: Bool) {
        if postAllAnswersFirst {
            postComment(comment: self.getUserInformationInDisplayFormat(), delayTime: delay/2)
        }
        self.pickerViewDataSource = self.conformationOptions
        self.postQuestion(delayTime: delay, questionType: .conformation)
    }

    private func countryCode(for fullCountryName : String) -> String? {
        let locale = NSLocale.current
        for localeCode in NSLocale.isoCountryCodes {
            let countryName = locale.localizedString(forRegionCode: localeCode)
            if fullCountryName.lowercased() == countryName?.lowercased() {
                return localeCode
            }
        }
        return nil
    }

    fileprivate func checkUsernameAvailability(_ text: String) {
        let usernameTxt = text.trimmingCharacters(in: .whitespaces).lowercased()
        dataConnector.isUsernameTaken(usernameTxt) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let taken):
                if taken {
                    let errorMessage = LocalString.Reg.Message.usernameUnavailable(text)
                    self.postComment(comment: errorMessage, delayTime: self.oneSecond)
                } else {
                    self.postComment(comment: LocalString.Reg.Message.usernameAvailable, delayTime: self.oneSecond + 500)
                    self.userInfo.username = usernameTxt
                    if self.editingQuestionMode {
                        self.askConformationQuestionAfterDelay(delay: self.oneSecond + 1500, postAllAnswersFirst: true)
                    } else {
                        self.postQuestion(delayTime: self.oneSecond + 1500, questionType: .email)
                    }
                }
            case .failure:
                self.postComment(comment: LocalString.Reg.Error.notConnectedGeneral, delayTime: self.oneSecond + 500)
            }
        }
    }

    fileprivate func handleInput(forUsername text: String) {
        var usernameTxt = text
        usernameTxt = usernameTxt.trimmingCharacters(in: .whitespaces)
        usernameTxt = usernameTxt.lowercased()
        let validation = isValidUsername(username: usernameTxt)
        if validation.error {
            postComment(comment: validation.errorMessage!, delayTime: oneSecond)
        } else {
            if !dataConnector.isConnectedToInternet() {
                self.postComment(comment: LocalString.Reg.Error.notConnected, delayTime: oneSecond)
                return
            }
            self.postComment(comment: LocalString.Reg.Message.checkUsername, delayTime: self.oneSecond, withImageName: "justWait", commentType: .commentWithImage)
            checkUsernameAvailability(text)
        }
    }

    fileprivate func checkEmailAvailability(_ emailTxt: String) {
        dataConnector.isEmailAvailable(emailTxt) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let available):
                if available {
                    self.postComment(comment: LocalString.Reg.Message.emailAvailable, delayTime: self.oneSecond)
                    self.userInfo.email = emailTxt
                    if self.editingQuestionMode {
                        self.askConformationQuestionAfterDelay(delay: self.oneSecond + 500, postAllAnswersFirst: true)
                    } else {
                        self.postQuestion(delayTime: self.oneSecond + 500, questionType: .password)
                    }
                } else {
                    self.postComment(comment: LocalString.Reg.Message.emailUnavailable, delayTime: self.oneSecond)
                }
            case .failure:
                self.postComment(comment: LocalString.Reg.Error.notConnectedGeneral, delayTime: self.oneSecond)
            }
        }
    }

    fileprivate func handleInput(forEmail text: String) {
        var emailTxt = text
        emailTxt = emailTxt.trimmingCharacters(in: .whitespaces).lowercased()
        let validation = isValidEmail(email: emailTxt)
        if validation.error {
            postComment(comment: validation.errorMessage!, delayTime: oneSecond)
        } else {
            if !dataConnector.isConnectedToInternet() {
                self.postComment(comment: LocalString.Reg.Error.notConnected, delayTime: oneSecond)
                return
            }
            self.postComment(comment: LocalString.Reg.Message.emailAvailabilityCheck, delayTime: 200)
            checkEmailAvailability(emailTxt)
        }
    }

    fileprivate func handleInput(forPassword text: String) {
        var password = text
        password = password.trimmingCharacters(in: .whitespaces)
        let validation = isValidPassword(password: password)
        if validation.error {
            postComment(comment: validation.errorMessage!, delayTime: oneSecond)
        } else {
            self.userInfo.password = password
            if self.editingQuestionMode {
                self.askConformationQuestionAfterDelay(delay: self.oneSecond, postAllAnswersFirst: true)
            } else {
                postQuestion(delayTime: oneSecond, questionType: .nickname)
            }
        }
    }

    fileprivate func handleInput(forNickname text: String) {
        var nickname = text
        nickname = nickname.trimmingCharacters(in: .whitespaces)
        nickname = nickname.replacingOccurrences(of: " ", with: "")
        let validation = isValidNickname(nickname: nickname)
        if validation.error {
            postComment(comment: validation.errorMessage!, delayTime: oneSecond)
        } else {
            self.userInfo.nickname = text
            if self.editingQuestionMode {
                self.askConformationQuestionAfterDelay(delay: self.oneSecond, postAllAnswersFirst: true)
            } else {
                self.pickerViewDataSource = ageYear
                postQuestion(delayTime: oneSecond, questionType: .yearOfBirth)
            }
        }
    }

    fileprivate func handleInput(forConfirmation text: String) {
        self.editingQuestionMode = false
        if text == LocalString.Reg.no {
            self.pickerViewDataSource = self.editingOptions
            postQuestion(delayTime: 500, questionType: .editingOption)
        } else if text == LocalString.Reg.yes {
            self.postComment(comment: LocalString.Reg.Message.userConfirmQuestions, delayTime: oneSecond)
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1500), execute: { [weak self] in
                self?.registerUser()
            })
        }
    }

    fileprivate func handleInput(forEditingAnswer text: String) {
        if text == LocalString.Reg.cancel {
            self.pickerViewDataSource = self.conformationOptions
            postQuestion(delayTime: 500, questionType: .conformation)
        } else {
            self.editingQuestionMode = true
            switch text {
            case LocalString.Reg.username:
                postQuestion(delayTime: 500, questionType: .username)
            case LocalString.Reg.email:
                postQuestion(delayTime: 500, questionType: .email)
            case LocalString.Reg.password:
                postQuestion(delayTime: 500, questionType: .password)
            case LocalString.Reg.nickname:
                postQuestion(delayTime: 500, questionType: .nickname)
            case LocalString.Reg.yearOfBirth:
                self.pickerViewDataSource = ageYear
                postQuestion(delayTime: 500, questionType: .yearOfBirth)
            case LocalString.Reg.gender:
                self.pickerViewDataSource = self.genders
                postQuestion(delayTime: 500, questionType: .gender)
            case LocalString.Reg.country:
                self.pickerViewDataSource = self.listOfCountries
                postQuestion(delayTime: 500, questionType: .country)
            case LocalString.Reg.city:
                postQuestion(delayTime: 500, questionType: .city)
            default:
                break
            }
        }
    }

    fileprivate func handleInput(forYearOfBirth text: String) {
        self.userInfo.yearOfBirth = text
        if self.editingQuestionMode {
            self.askConformationQuestionAfterDelay(delay: self.oneSecond, postAllAnswersFirst: true)
        } else {
            self.pickerViewDataSource = genders
            postQuestion(delayTime: oneSecond, questionType: .gender)
        }
    }

    fileprivate func handleInput(forGender text: String) {
        self.userInfo.gender = String(text.first ?? "m")
        if self.editingQuestionMode {
            self.askConformationQuestionAfterDelay(delay: self.oneSecond, postAllAnswersFirst: true)
        } else {
            self.pickerViewDataSource = listOfCountries
            postQuestion(delayTime: oneSecond, questionType: .country)
        }
    }

    fileprivate func handleInput(forCountry text: String) {
        self.userInfo.country = text
        self.countryCode = countryCode(for: text)
        self.pickerViewDataSource = []
        if self.editingQuestionMode {
            self.askConformationQuestionAfterDelay(delay: self.oneSecond, postAllAnswersFirst: true)
        } else {
            postQuestion(delayTime: oneSecond, questionType: .city)
        }
    }

    fileprivate func handleInput(forCity text: String) {
        let cityName = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if !isValidCityName(cityName) {
            if cityName.hasEmoji() {
                postComment(comment: LocalString.Reg.Error.cityNameEmojiError, delayTime: 200)
            } else {
                postComment(comment: LocalString.Reg.Error.cityNameError, delayTime: 200)
            }

            return
        }

        self.userInfo.city = cityName
        self.askConformationQuestionAfterDelay(delay: self.oneSecond, postAllAnswersFirst: true)
    }

    private func chatUserInput(text: String) {
        postUserAnswer(answer: text)
        switch self.currentQuestionType {
        case .username:
            handleInput(forUsername: text)
        case .email:
            handleInput(forEmail: text)
        case .password:
            handleInput(forPassword: text)
        case .nickname:
            handleInput(forNickname: text)
        case .yearOfBirth:
            handleInput(forYearOfBirth: text)
        case .gender:
            handleInput(forGender: text)
        case .country:
            handleInput(forCountry: text)
        case .city:
            handleInput(forCity: text)
        case .conformation:
            handleInput(forConfirmation: text)
        case .editingOption:
            handleInput(forEditingAnswer: text)
        default:
            break
        }
    }

    fileprivate func registerUser() {
        if !dataConnector.isConnectedToInternet() {
            self.postComment(comment: LocalString.Reg.Error.notConnected, delayTime: oneSecond)
        }

        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(userInfo)
        guard let userInfoDataConnectorModel = try? JSONDecoder().decode(UserInfoDataConnectorModel.self, from: jsonData) else { return  }

        dataConnector.register(user: userInfoDataConnectorModel) { [weak self] result in
            switch result {
            case .success(let userInfo):
                print(userInfo)
                self?.registrationCompleted.value = (true, userInfo)
            case .failure:
                self?.postComment(comment: LocalString.Reg.Error.notConnected, delayTime: self?.oneSecond ?? 0)
            }
        }
    }

    func getUserInformationInDisplayFormat() -> String {
        var completedAnswersComment = LocalString.Reg.Message.completedAnswers
        var userGender = ""
        if let theGender = self.userInfo.gender {
            if theGender.lowercased() == "m"{
                userGender = LocalString.Reg.male
            } else if theGender.lowercased() == "f" {
                userGender = LocalString.Reg.female
            } else if theGender.lowercased() == "o" {
                userGender = LocalString.Reg.other
            }
        }

        completedAnswersComment.append(contentsOf: "\n")
        completedAnswersComment.append(contentsOf: "\(LocalString.Reg.username): \(self.userInfo.username ?? "")\n")
        completedAnswersComment.append(contentsOf: "\(LocalString.Reg.email): \(self.userInfo.email ?? "")\n")
        completedAnswersComment.append(contentsOf: "\(LocalString.Reg.password): \(self.userInfo.password ?? "")\n")
        completedAnswersComment.append(contentsOf: "\(LocalString.Reg.nickname): \(self.userInfo.nickname ?? "")\n")
        completedAnswersComment.append(contentsOf: "\(LocalString.Reg.gender): \(userGender)\n")
        completedAnswersComment.append(contentsOf: "\(LocalString.Reg.yearOfBirth): \(self.userInfo.yearOfBirth ?? "")\n")
        completedAnswersComment.append(contentsOf: "\(LocalString.Reg.city): \(self.userInfo.city ?? "")\n")
        completedAnswersComment.append(contentsOf: "\(LocalString.Reg.country): \(self.userInfo.country ?? "")\n")
        return completedAnswersComment
    }
}
