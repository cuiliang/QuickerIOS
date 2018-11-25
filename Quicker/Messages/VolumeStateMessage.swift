//
//  VolumeStateMessage.swift
//  Quicker
//
//  Created by CuiLiang on 2018/7/12.
//  Copyright © 2018年 CuiLiang. All rights reserved.
//

import Foundation

class VolumeStateMessage: NetMessageBase, Decodable {
    let MessageType = 2
    
    var Mute: Bool = false
    
    var MasterVolume: Int = 0
    
    override func getMessageType() -> Int{
        return MessageType
    }
}
