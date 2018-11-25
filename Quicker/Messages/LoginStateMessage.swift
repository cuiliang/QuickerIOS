//
//  LoginStateMessage.swift
//  Quicker
//
//  Created by CuiLiang on 2018/10/15.
//  Copyright © 2018年 CuiLiang. All rights reserved.
//

import Foundation


class LoginStateMessage: NetMessageBase, Decodable {
    let MessageType: Int = 201
    
    var IsLoggedIn: Bool = false
    
    var ErrorCode: Int = 0
    
    var ErrorMessage: String?
    
    override func getMessageType() -> Int{
        return MessageType
    }
}


