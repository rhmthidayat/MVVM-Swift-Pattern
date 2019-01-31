//
//  APIService.swift
//  mvvm
//
//  Created by Rahmat Hidayat on 29/01/19.
//  Copyright © 2019 Rahmat. All rights reserved.
//

import Foundation
import Alamofire

enum APIError: String, Error {
    case noNetwork = "No Network"
    case serverOverload = "Server is overloaded"
    case permissionDenied = "You don't have permission"
}

protocol APIServiceProtocol {
    func fetchNews(withParams params: [String:String], complete: @escaping (_ success: Bool, _ news: News, _ error: APIError?)-> Void)
}

class APIService: APIServiceProtocol {
    
    func fetchNews(withParams params: [String : String], complete: @escaping (Bool, News, APIError?)-> Void) {
        Alamofire.request(Constants.baseUrl).responseJSON{ response in
            if let data = response.data, let statusCode = response.response?.statusCode, statusCode == 200 {
                let result = try! newJSONDecoder().decode(News.self, from: data)
                complete(true, result, nil)
            }
        }
    }
    
}
