//
//  DeviceLoginMessage.swift
//  Quicker
//
//  Created by CuiLiang on 2018/10/15.
//  Copyright © 2018年 CuiLiang. All rights reserved.
//

import Foundation

class DeviceLoginMessage: SendingMessageBase, Encodable {
    let MessageType: Int = 200
    
    var ConnectionCode: String = ""
    
    var Version: String = ""
    
    var DeviceName: String?
    
    override func getMessageType() -> Int{
        return MessageType
    }
}
