//
//  ViewController.swift
//  OnTheMap
//
//  Created by Maverick on 2022/1/8.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginWithFacebook: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
    }

    @IBAction func loginTapped(_ sender: Any) {
        self.setLoggingIn(status: true)
        UDacityAPI.login(username: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "") { success, error in
            if success {
                self.setLoggingIn(status: false)
                self.performSegue(withIdentifier: "loginVC", sender: nil)
            } else {
                self.showAlertViewController(title: "Login Failed", message: error?.localizedDescription ?? "")
                self.setLoggingIn(status: false)
            }
        }
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        UIApplication.shared.open(UDacityAPI.Endpoints.signUp.url, options: [:], completionHandler: nil)
    }
    
    func setLoggingIn(status: Bool) {
        if status {
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.stopAnimating()
        }
        self.emailTextField.isEnabled = !status
        self.passwordTextField.isEnabled = !status
        self.loginButton.isEnabled = !status
        self.signUpButton.isEnabled = !status
        self.loginWithFacebook.isEnabled = !status
    }
    
}
