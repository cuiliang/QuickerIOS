//
//  ToggleMuteMessage.swift
//  Quicker
//
//  Created by CuiLiang on 2018/7/12.
//  Copyright © 2018年 CuiLiang. All rights reserved.
//

import Foundation

class ToggleMuteMessage: SendingMessageBase, Encodable {
    let MessageType:Int = 102
    
    override func getMessageType() -> Int{
        return MessageType
    }
}
