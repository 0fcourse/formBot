//
//  ProfileVC.swift
//  FromBot
//
//  Created by Marwan Aziz on 12/06/2020.
//  Copyright © 2020 Marwan Aziz. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet weak var lblGreeting: UILabel!
    @IBOutlet weak var lblNickname: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    fileprivate var viewModel: ProfileViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        initialisation()
    }

    fileprivate func initialisation() {
        viewModel = ProfileViewModel()
        bindViewModel()
    }

    fileprivate func bindViewModel() {

        viewModel?.greetingMessage.bind { [weak self] greeting in
            self?.lblGreeting.text = greeting
        }

        viewModel?.nickname.bind { [weak self] nickname in
            self?.lblNickname.text = nickname
        }

        viewModel?.username.bind { [weak self] username in
            self?.lblUsername.text = username
        }

        viewModel?.email.bind { [weak self] email in
            self?.lblEmail.text = email
        }

        viewModel?.gender.bind { [weak self] gender in
            self?.lblGender.text = gender
        }

        viewModel?.city.bind { [weak self] city in
            self?.lblCity.text = city
        }

        viewModel?.country.bind { [weak self] country in
            self?.lblCountry.text = country
        }

        viewModel?.noLoggedInUserFound.bind { [weak self] noUser in
            if noUser {
                self?.dismissTheView()
            }
        }
    }

    @IBAction func signOut(_ sender: Any) {
        dismissTheView()
        viewModel?.signOut()
    }

    fileprivate func dismissTheView() {
        if let rootNavigation = UIApplication.shared.windows.first?.rootViewController as? UINavigationController {
            if let loginVC = rootNavigation.children.first(where: { $0 is LoginVC }) {
                rootNavigation.popToViewController(loginVC, animated: false)
                self.dismiss(animated: true, completion: nil)
                return
            } else {
                let loginVC = instantiateLoginViewController()
                rootNavigation.addChild(loginVC)
                rootNavigation.popToViewController(loginVC, animated: true)
                return
            }
        }

        self.dismiss(animated: true, completion: nil)
    }

    fileprivate func instantiateLoginViewController() -> UIViewController {
        let storyBoard = UIStoryboard(name: "Login", bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: "loginVC")
    }
}
