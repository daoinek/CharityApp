//
//  LoginViewController.swift
//  Donategram
//
//  Created by Yevhenii Kovalenko on 26.05.2020.
//  Copyright © 2020 Yevhenii Kovalenko. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInLabel: UILabel!
    @IBOutlet weak var haveAccButton: UIButton!
    @IBOutlet weak var signInButton: GIDSignInButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        passwordField.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        hideKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        emailField.text = nil
        passwordField.text = nil
    }
    
    @IBAction func googleDidTap(_ sender: GIDSignInButton) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    @IBAction func startButtonDidTap(_ sender: UIButton) {
        let email = emailField.text!
        let password = passwordField.text!
        if email == "" || password == "" {
            showAlert(withText: "Fields is empty!")
        } else {
            self.view.showBlurLoader()
            signIn(withEmail: email, password: password)
        }
    }
    
   func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
    if let error = error {
    print(error.localizedDescription)
    return
    }
    guard let auth = user.authentication else { return }
    let credentials = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
    Auth.auth().signIn(with: credentials) { (authResult, error) in
    if let error = error {
    print(error.localizedDescription)
    } else {
    print("Login Successful.")
        self.performSegue(withIdentifier: "startAppSegue", sender: nil)
    }}
    }
    
    @IBAction func haveAccButtonDidTap(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToRegistr", sender: nil)
    }
    
    fileprivate func showAlert(withText text: String) {
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func signIn(withEmail email: String, password: String) {
        AuthApiManager.login(with: RegisterUserModel(email: email,
                                                     password: password,
                                                     passwordconfirm: "",
                                                     firstname: "",
                                                     lastname: "")) { (response) in
            switch response.result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.view.removeBlurLoader()
                }
                print("(Debug) Error all post loader: \(String(describing: error.errorDescription))")
                self.showAlert(withText: error.errorDescription!)
            case .success:
                if response.response?.statusCode == 200 {
                    let data = response.value as! [String: Any]
                    let token = data["token"] as? String ?? ""
                    DispatchQueue.main.async {
                        self.view.removeBlurLoader()
                    }
                        HomeViewController.userToken = token
                        self.performSegue(withIdentifier: "startAppSegue", sender: nil)
                    return
                } else {
                    DispatchQueue.main.async {
                        self.view.removeBlurLoader()
                    }
                    print("(Debug) register error with code: \(String(describing: response.response?.statusCode))")
                    self.showAlert(withText: "Something went wrong with status code \(String(describing: response.response?.statusCode))")
                }
            }
        }
    }
}

extension LoginViewController {
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(LoginViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}

extension UIViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKey()
        return true
    }
    
    func hideKey() {
        self.view.endEditing(true)
    }

}

extension LoginViewController: GIDSignInDelegate {
    
}
