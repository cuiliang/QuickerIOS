//
//  UpdateButtonsMessage.swift
//  Quicker
//
//  Created by CuiLiang on 2018/7/12.
//  Copyright © 2018年 CuiLiang. All rights reserved.
//

import Foundation




class UpdateButtonsMessage: NetMessageBase, Decodable {
    let MessageType: Int = 1
    
    var ProfileName: String? = "";
    
    var Buttons: [ButtonItem]? = [ButtonItem]()
    
    struct ButtonItem: Decodable {
        var Index: Int? = 0
        var IsEnabled: Bool? = false
        var Label: String? = ""
        var IconFileName: String? = ""
        var IconFileContent: String? = ""
    }
    
    override func getMessageType() -> Int{
        return MessageType
    }
}
