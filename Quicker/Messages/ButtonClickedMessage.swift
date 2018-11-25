//
//  ButtonClickedMessage.swift
//  Quicker
//
//  Created by CuiLiang on 2018/7/12.
//  Copyright © 2018年 CuiLiang. All rights reserved.
//

import Foundation

class ButtonClickedMessage: SendingMessageBase, Encodable {
    let MessageType: Int = 101
    
    var ButtonIndex: Int = 0
    
    override func getMessageType() -> Int{
        return MessageType
    }
}
