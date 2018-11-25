//
//  NetMessageBase.swift
//  Quicker
//
//  Created by CuiLiang on 2018/7/11.
//  Copyright © 2018年 CuiLiang. All rights reserved.
//

import Foundation

class  NetMessageBase {
    func getMessageType() -> Int {
        fatalError("Must override getMessageType()")
    }
    
}

// 要发送的消息
class SendingMessageBase: NetMessageBase {
    
}
