//
//  CommandMessage.swift
//  Quicker
//
//  Created by CuiLiang on 2018/7/12.
//  Copyright © 2018年 CuiLiang. All rights reserved.
//

import Foundation

class CommandMessage: SendingMessageBase, Encodable {
    let MessageType: Int = 110
    
    var Command: String = ""
    
    var Data: String = ""
    
    override func getMessageType() -> Int{
        return MessageType
    }
}
