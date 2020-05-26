//
//  PaymentViewController.swift
//  Donategram
//
//  Created by Yevhenii Kovalenko on 26.05.2020.
//  Copyright © 2020 Yevhenii Kovalenko. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController {
    
    @IBOutlet weak var countTextField: UITextField!
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var monthYearField: UITextField!
    @IBOutlet weak var cvvField: UITextField!
    @IBOutlet weak var payButton: UIButton!
    
    static var paymantData: [DonateModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        payButton.layer.cornerRadius = 10
        payButton.layer.masksToBounds = true
        monthYearField.delegate = self
        numberField.addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)
        monthYearField.addTarget(self, action: #selector(didChangeDateText(textField:)), for: .editingChanged)
    }
    
    @objc func didChangeText(textField:UITextField) {
        numberField.text = self.modifyCreditCardString(creditCardString: textField.text!)
    }
    
    @objc func didChangeDateText(textField:UITextField) {
        monthYearField.text = self.modifyDateString(dateString: textField.text!)
    }
    
    fileprivate func showAlert(withText text: String) {
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func modifyCreditCardString(creditCardString : String) -> String {
        let trimmedString = creditCardString.components(separatedBy: .whitespaces).joined()
        let arrOfCharacters = Array(trimmedString)
        var modifiedCreditCardString = ""
        if(arrOfCharacters.count > 0) {
            for i in 0...arrOfCharacters.count-1 {
                modifiedCreditCardString.append(arrOfCharacters[i])
                if((i+1) % 4 == 0 && i+1 != arrOfCharacters.count){
                    modifiedCreditCardString.append(" ")
                    }
                }
            }
        return modifiedCreditCardString
    }
    
    fileprivate func modifyDateString(dateString : String) -> String {
        let trimmedString = dateString.components(separatedBy: .whitespaces).joined()
        let arrOfCharacters = Array(trimmedString)
        var modifiedCreditCardString = ""
        if(arrOfCharacters.count > 0) {
            for i in 0...arrOfCharacters.count-1 {
                modifiedCreditCardString.append(arrOfCharacters[i])
                if (i+1) == 2 {
                    if arrOfCharacters.count > 2 {
                        if arrOfCharacters[2] == "/" {} else {
                            modifiedCreditCardString.append("/")
                        }
                    }
                }
                }
            }
        return modifiedCreditCardString
    }
    
    @IBAction func payDidTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension PaymentViewController {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == monthYearField {
            monthYearField.isSecureTextEntry = false
        }
    }
}

extension PaymentViewController {
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(PaymentViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}

extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}
