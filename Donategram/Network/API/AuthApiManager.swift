//
//  AuthApiManager.swift
//  Donategram
//
//  Created by Yevhenii Kovalenko on 26.05.2020.
//  Copyright © 2020 Yevhenii Kovalenko. All rights reserved.
//

import Foundation
import Alamofire

struct AuthApiManager {
    static let baseURL = "https://charityappppp.azurewebsites.net/api/"
    
    static func register(with model: RegisterUserModel, complition: @escaping (_ response: DataResponse<Any,AFError>)->Void) {
        let param = ["email": model.email,
                     "password": model.password,
                     "passwordconfirm": model.passwordconfirm,
                     "firstname": model.firstname,
                     "lastname": model.lastname]
        print("WE SAND DATA: \(model)")
        let headers: HTTPHeaders = ["Content-Type":"application/json"]
        AF.request(baseURL + "users/register",
               method: .post,
               parameters: param,
               encoder: JSONParameterEncoder.default,
               headers: headers).responseJSON { response in
                complition(response)
        }
    }
    
    static func login(with model: RegisterUserModel, complition: @escaping (_ response: DataResponse<Any,AFError>)->Void) {
        let param = ["email": model.email,
                     "password": model.password]
        let headers: HTTPHeaders = ["Content-Type":"application/json"]
        AF.request(baseURL + "users/login",
               method: .post,
               parameters: param,
               encoder: JSONParameterEncoder.default,
               headers: headers).responseJSON { response in
                complition(response)
        }
    }
}
