//
//  RegisterVC.swift
//  jawaz
//
//  Created by Marwan Aziz on 02/08/2018.
//  Copyright © 2018 Marwan Aziz. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import GooglePlaces
import GoogleMapsBase
import IQKeyboardManagerSwift

class RegisterVC: UIViewController, ChatInputDelegate {

    enum CellIdentifier: String {
        case basicQuestion = "BasicQuestion"
        case questionAnswer = "QuestionAnswer"
        case commentWithImage = "commentWithImage"
    }

    @IBOutlet weak var inputContainer: UIView!
    @IBOutlet weak var constraintInputViewBottom: NSLayoutConstraint!
    @IBOutlet weak var constraintInputViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    var TextInputView: ChatInput?
    let viewModel: RegistrationViewModel = RegistrationViewModel()

    fileprivate func handleInput(ForQuestionType type: QuestionType) {
        switch type {
        case .email:
            self.resetKeyboardInputViewIfNeeded()
            self.TextInputView?.txtMessage.keyboardType = .emailAddress
            self.TextInputView?.txtMessage.textContentType = .emailAddress
            self.TextInputView?.txtMessage.autocapitalizationType = .none
        case .country, .gender, .yearOfBirth, .conformation, .editingOption:
            self.presentPickerViewAfterDelayForData(delay: 200)
        case .city:
            self.TextInputView?.txtMessage.keyboardType = .default
            self.resetKeyboardInputViewIfNeeded()
            self.TextInputView?.txtMessage.resignFirstResponder()
            self.TextInputView?.txtMessage.inputView = nil
            guard let countryCode = self.viewModel.selectedCountryCode else {
                return
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {[weak self] in
                self?.showGooglePlacesCityPicker(forCountry: countryCode)
            })
        case .username:
            self.resetKeyboardInputViewIfNeeded()
            self.TextInputView?.txtMessage.keyboardType = .default
            self.TextInputView?.txtMessage.textContentType = .username
            self.TextInputView?.txtMessage.autocapitalizationType = .none
            self.TextInputView?.txtMessage.autocorrectionType = .no
        case .password:
            self.resetKeyboardInputViewIfNeeded()
            self.TextInputView?.txtMessage.keyboardType = .default
            self.TextInputView?.txtMessage.textContentType = .password
            self.TextInputView?.txtMessage.autocapitalizationType = .none
            self.TextInputView?.txtMessage.autocorrectionType = .no
        case .nickname:
            self.resetKeyboardInputViewIfNeeded()
            self.TextInputView?.txtMessage.keyboardType = .default
            self.TextInputView?.txtMessage.textContentType = .nickname
            self.TextInputView?.txtMessage.autocapitalizationType = .none
            self.TextInputView?.txtMessage.autocorrectionType = .no
        default:
            self.resetKeyboardInputViewIfNeeded()
            self.TextInputView?.txtMessage.keyboardType = .default
        }
    }

    fileprivate func bindViewModel() {

        viewModel.userInteractionEnabled.bind { enable in
            self.TextInputView?.txtMessage.isUserInteractionEnabled = enable
        }

        viewModel.updateInput.bind { [weak self] input in
            guard let self = self else { return }
            let inputType = input.0
            let questionType = input.1
            switch inputType {
            case .basicQuestion:
                self.TextInputView?.txtMessage.keyboardType = .default
                self.handleInput(ForQuestionType: questionType)
                self.TextInputView?.txtMessage.reloadInputViews()

            case .dataPickerQuestion:
                break
            default:
                break
            }
            self.tableView.reloadData()
            self.scrollToBottom(animation: false, delay: 0)
        }

        viewModel.registrationCompleted.bind { [unowned self] (completed) in
            if completed {
                self.TextInputView?.txtMessage.resignFirstResponder()
                self.performSegue(withIdentifier: "reg_to_profile", sender: self)
            }
        }
    }

    fileprivate func registerCells() {
        tableView.register(UINib(nibName: "CommentWithImageCell", bundle: nil), forCellReuseIdentifier: CellIdentifier.commentWithImage.rawValue)
        tableView.register(UINib(nibName: "Question", bundle: nil), forCellReuseIdentifier: CellIdentifier.basicQuestion.rawValue)
        tableView.register(UINib(nibName: "QuestionAnswerCell", bundle: nil), forCellReuseIdentifier: CellIdentifier.questionAnswer.rawValue)
    }

    fileprivate func Initialisation() {
        bindViewModel()
        initialiseInputView()
        self.constraintInputViewHeight.isActive = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
        registerCells()
        tableView.keyboardDismissMode = .none
        let tableTouch = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.tableView.addGestureRecognizer(tableTouch)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LocalString.Reg.registration
        Initialisation()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()

    }

    fileprivate var bottomSafeArea: CGFloat {
        if #available(iOS 11.0, *) {
            return view.safeAreaInsets.bottom
        }
        return 0
    }

    fileprivate func initialiseInputView() {
        if let userInputView = getInputView() as? ChatInput {
            TextInputView = userInputView
            TextInputView?.translatesAutoresizingMaskIntoConstraints = false
            TextInputView?.textMaxLimit = 50
            TextInputView?.ConstraintContainerBottom.constant = bottomSafeArea
            self.inputContainer.addSubview(TextInputView!)
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[TextinputView]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["TextinputView":TextInputView!]))
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[TextinputView]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["TextinputView":TextInputView!]))
            TextInputView?.delegate = self
        }
    }

    fileprivate func resetKeyboardInputViewIfNeeded() {
        if let inputView = self.TextInputView?.txtMessage.inputView, inputView.isKind(of: UIPickerView.self) {
            self.TextInputView?.txtMessage.inputView = nil
        }
    }

    @objc fileprivate func hideKeyboard() {
        if self.TextInputView?.txtMessage.isFirstResponder ?? false {
            self.TextInputView?.txtMessage.resignFirstResponder()
        }
    }

    @objc func keyboardChange(notification:NSNotification) {
        var scrollToBottomOfTableView = false
        if let userInfo = notification.userInfo {
            if let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                if notification.name == UIResponder.keyboardWillHideNotification {
                    TextInputView?.ConstraintContainerBottom.constant = 0
                } else {
                    TextInputView?.ConstraintContainerBottom.constant = -keyboardSize.height + bottomSafeArea
                    scrollToBottomOfTableView = true
                }
            }
            UIView.animate(withDuration: 0.5) {
                self.view.layoutSubviews()
            }
            UIView.animate(withDuration: 0.5, animations: {[weak self] in
                self?.view.layoutIfNeeded()
            }) { (finished)  in
                if scrollToBottomOfTableView && finished {
                    self.scrollToBottom(animation: true, delay: 0)
                }
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }

    fileprivate func scrollToBottom(animation:Bool, delay:Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delay), execute: { [weak self] in
            let numberOfRows = self?.tableView.numberOfRows(inSection: 0) ?? 0
            let row = numberOfRows - 1
            if  row > -1 {
                let indexPath = IndexPath(item:row , section: 0)
                self?.tableView.scrollToRow(at: indexPath, at: .bottom, animated: animation)
            }
        })
    }

    fileprivate func getInputView() -> UIView {
        let thisInputView: UIView = {
            guard let contentView = Bundle.main.loadNibNamed("ChatInput", owner: self, options: nil)?.first as? UIView else {    // 3
                // xib not loaded, or its top view is of the wrong type
                return UIView()
            }
            return contentView
        }()
        return thisInputView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: InputView Delegate
    func chatInputSend(text: String) {
        viewModel.userInput(input: text)
    }

    func chatInputHeightDidChange(height: CGFloat) {
        self.scrollToBottom(animation: true, delay: 0)
    }
}

// MARK: Table view delegate
extension RegisterVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.conversationCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if viewModel.conversationCount > indexPath.row {
            let inputObject = viewModel.conversationDataSource[indexPath.row]
            inputObject.index = indexPath.row
            if inputObject.inputType == .comment {
                if let theCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.basicQuestion.rawValue) as? QuestionTableViewCell {
                    theCell.setText(inputObject.text)
                    return theCell
                }
            } else if inputObject.inputType == .commentWithImage {
                if let theCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.commentWithImage.rawValue) as? CommentWithImageCell {
                    theCell.setText(inputObject.text, imageName: inputObject.imageName)
                    return theCell
                }
            } else if inputObject.inputType == .questionAnswer {
                if let theCell = tableView.dequeueReusableCell(withIdentifier:CellIdentifier.questionAnswer.rawValue) as? QuestionAnswerTableViewCell {
                    theCell.setText(inputObject.text)
                    return theCell
                }

            } else if inputObject.inputType == .basicQuestion {
                if let theCell = tableView.dequeueReusableCell(withIdentifier:CellIdentifier.basicQuestion.rawValue) as? QuestionTableViewCell {
                    if let questionObject = inputObject as? RegistrationQuestion {
                        theCell.setText(questionObject.question)
                    }

                    return theCell
                }
            }
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell is CommentWithImageCell {
            cell.layoutSubviews()
        }
    }
}

// MARK: Picker View
extension RegisterVC: UIPickerViewDelegate, UIPickerViewDataSource {

    func presentPickerViewAfterDelayForData(delay:Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delay), execute: {[weak self] in
            let pickerView = UIPickerView()
            pickerView.delegate = self
            pickerView.dataSource = self
            pickerView.backgroundColor = UIColor(named: "backGround") ?? .white
            self?.TextInputView?.txtMessage.inputView = pickerView
            if self?.TextInputView?.txtMessage.isFirstResponder  ?? false {
                self?.TextInputView?.txtMessage.reloadInputViews()

            } else {
                self?.TextInputView?.txtMessage.becomeFirstResponder()
            }
        })
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.viewPickerDataSource.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard viewModel.viewPickerDataSource.count > row else {
            return ""
        }
        return viewModel.viewPickerDataSource[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedItem = viewModel.viewPickerDataSource[row]
        self.TextInputView?.txtMessage.text = selectedItem
    }
}

// MARK: Google places delegate
extension RegisterVC: GMSAutocompleteViewControllerDelegate {

    fileprivate func showGooglePlacesCityPicker(forCountry countryCode: String) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self

        // Set a filter to return only addresses.
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        filter.country = countryCode
        autocompleteController.autocompleteFilter = filter
        autocompleteController.tableCellBackgroundColor = UIColor(named: "backGround") ?? .white
        autocompleteController.tableCellSeparatorColor = UIColor(named: "backGround") ?? .white
        autocompleteController.modalPresentationStyle = .fullScreen
        present(autocompleteController, animated: true, completion: nil)
    }

    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.viewModel.userInput(input: place.name ?? "")
        dismiss(animated: true, completion: nil)
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        self.viewModel.postComment(LocalString.Reg.Message.citySearchError)
    }

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
        viewModel.pickingCityCanceled()

    }

    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {}

    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {}
}
