//
//  LoginVCViewController.swift
//  FromBot
//
//  Created by Marwan Aziz on 11/06/2020.
//  Copyright © 2020 Marwan Aziz. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var fieldUsername: UITextField!
    @IBOutlet weak var fieldPassword: UITextField!
    @IBOutlet weak var lblError: UILabel!
    fileprivate var viewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        initialisation()
    }

    fileprivate func initialisation() {
        fieldUsername.delegate = self
        fieldPassword.delegate = self
        observeTextFields()
        bindViewModel()
    }

    fileprivate func bindViewModel() {
        viewModel.loginError.bind { [weak self] error in
            self?.lblError.text = error
            self?.lblError.isHidden = error == nil
        }

        viewModel.userLoggedIn.bind {[weak self] loggedIn in
            if loggedIn {
                self?.performSegue(withIdentifier: "loginToProfile", sender: nil)
            }
        }
    }

    @IBAction fileprivate func loginPressed(_ sender: Any) {
        self.view.endEditing(true)
        viewModel.login()
    }

    fileprivate func clearFields() {
        fieldPassword.text = ""
        fieldUsername.text = ""
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        clearFields()
        removeFieldsObserver()
    }

    fileprivate func removeFieldsObserver() {
        fieldPassword.removeTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        fieldUsername.removeTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    fileprivate func observeTextFields() {
        fieldPassword.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        fieldUsername.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    fileprivate func setUsername(_ username: String?) {
        viewModel.username = username
    }

    fileprivate func setPassword(_ password: String?) {
        viewModel.password = password
    }
}

extension LoginVC: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fieldUsername {
            fieldPassword.becomeFirstResponder()
        } else {
            fieldPassword.resignFirstResponder()
            loginPressed(self)
        }

        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        viewModel.fieldStartEditing()
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == fieldUsername {
            setUsername(textField.text)
        } else if textField == fieldPassword {
            setPassword(textField.text)
        }
    }
}
