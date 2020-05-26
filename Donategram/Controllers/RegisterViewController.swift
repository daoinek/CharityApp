//
//  RegisterViewController.swift
//  Donategram
//
//  Created by Yevhenii Kovalenko on 26.05.2020.
//  Copyright © 2020 Yevhenii Kovalenko. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordField.delegate = self
        firstNameField.delegate = self
        lastNameField.delegate = self
        confirmPasswordField.delegate = self
        hideKeyboard()
    }
    
    @IBAction func startButtonDidTap(_ sender: UIButton) {
        let firstName = firstNameField.text!
        let lastName = lastNameField.text!
        let email = emailTextField.text!
        let password = passwordField.text!
        let confPassword = confirmPasswordField.text!
        self.view.showBlurLoader()
        register(withData: RegisterUserModel(email: email,
                                             password: password,
                                             passwordconfirm: confPassword,
                                             firstname: firstName,
                                             lastname: lastName))
    }
    
    @IBAction func haveAccButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func register(withData model: RegisterUserModel) {
        AuthApiManager.register(with: model) { (response) in
            switch response.result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.view.removeBlurLoader()
                }
                print("(Debug) Error all post loader: \(error.errorDescription!)")
                self.showAlert(withText: String(describing: error.errorDescription))
            case .success:
                if response.response?.statusCode == 200 {
                    let data = response.value as! [String: Any]
                    let token = data["token"] as? String ?? ""
                    DispatchQueue.main.async {
                        self.view.removeBlurLoader()
                    }
                        HomeViewController.userToken = token
                        self.performSegue(withIdentifier: "showAppFromReg", sender: nil)
                    return
                } else {
                    DispatchQueue.main.async {
                        self.view.removeBlurLoader()
                    }
                    print("(Debug) register error with code: \(String(describing: response.response?.statusCode))")
                    self.showAlert(withText: "Passwords must have at least one non alphanumeric character and must have at least one uppercase ('A'-'Z').")
                    self.showAlert(withText: "Something went wrong with status code \(String(describing: response.response?.statusCode))")
                }
            }
        }
    }
    
    fileprivate func showAlert(withText text: String) {
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension RegisterViewController {
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(RegisterViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
