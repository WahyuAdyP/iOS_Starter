//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by Project Xcode Templates
//  Created by Wahyu Ady Prasetyo,
//

import Foundation

class ForgotPassVM {
    init() {
        
    }
    
    /// Send request to server
    ///
    /// - Parameters:
    ///   - userid: User identity used when register difference in every user (ex: email, code)
    ///   - onFailed: Action when request error
    ///   - onSuccess: Action when request success
    func forgotPassRequest(userid: String, onFailed: ((String) -> Void)?, onSuccess: ((String) -> Void)?) {
        if userid.isEmpty {
            onFailed?(ErrorConstant.completeForm)
            return
        }
        if !userid.isValidEmail {
            onFailed?(ErrorConstant.emailValidity)
            return
        }
        onSuccess?("Sukses")
        
        // Make request to server
//        ApiHelper.shared.example(value: <#T##String#>) { (json, isSuccess, message) in
//            is isSuccess {
//                success?("Sukses")
//            } else {
//                error?(message)
//            }
//        }
    }
}