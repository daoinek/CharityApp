//
//  DonateApiManager.swift
//  Donategram
//
//  Created by Yevhenii Kovalenko on 26.05.2020.
//  Copyright © 2020 Yevhenii Kovalenko. All rights reserved.
//

import UIKit
import Alamofire

struct DonateApiManager {
    static let baseURL = "https://charityappppp.azurewebsites.net/"
    
    static func getAllDonates(complition: @escaping (_ response: DataResponse<Any,AFError>)->Void) {
     //   var headers: HTTPHeaders = [:]
     /*   if token != "" {
            headers = ["Authorization": "Bearer \(token)"]
        } */
        AF.request(baseURL + "api/donates",
                   method: .get
                  /* headers: headers*/).responseJSON { response in
                complition(response)
        }
    }
    
    static func getDonate(withID id: Int, complition: @escaping (_ response: DataResponse<Any,AFError>)->Void) {
        AF.request(baseURL + "api/donates/\(id)",
                   method: .get
                  /* headers: headers*/).responseJSON { response in
                complition(response)
        }
    }
    
    static func addNewDonates(withData model: DonateModel, complition: @escaping (_ response: DataResponse<Any,AFError>)->Void) {
        let param = ["name": model.name,
                     "info": model.info,
                     "imgpath": model.imgPath]
        
        let headers: HTTPHeaders = ["Content-Type":"application/json"]
        AF.request(baseURL + "api/posts",
               method: .post,
               parameters: param,
               encoder: JSONParameterEncoder.default,
               headers: headers).responseJSON { response in
                print("(Debug) addNewPost response data: \(String(describing: response.data))")
                complition(response)
        }
    }
    
    static func updatePost(withData model: PostModel, andID id: Int, complition: @escaping (_ response: DataResponse<Any,AFError>)->Void) { /*
        let param = ["id": id,
                     "name": model.name,
                     "description": model.description,
                     "imgpath": model.imgpath,
                     "applicationUserId": model.applicationUserId] as [String : Any]
        
        let headers: HTTPHeaders = ["Content-Type":"application/json"]
        AF.request(baseURL + "api/posts",
               method: .put,
               parameters: param,
               encoder: JSONParameterEncoder.default,
               headers: headers).responseJSON { response in
                print("(Debug) updatePost response data: \(String(describing: response.data))")
                complition(response)
        } */
    }
}
