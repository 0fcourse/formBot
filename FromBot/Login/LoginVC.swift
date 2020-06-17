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

    @IBAction func loginPressed(_ sender: Any) {
        self.view.endEditing(true)
        viewModel.username = fieldUsername.text
        viewModel.password = fieldPassword.text
        viewModel.login()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fieldPassword.text = ""
        fieldUsername.text = ""
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
}
