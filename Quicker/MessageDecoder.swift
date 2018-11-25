//
//  MessageDecoder.swift
//  Quicker
//
//  Created by CuiLiang on 2018/7/11.
//  Copyright © 2018年 CuiLiang. All rights reserved.
//

import Foundation
import Messages


let PACKET_START_FLAG = 0xFFFFFFFF
let PACKET_END_FLAG = 0x00000000

let BUFFER_SIZE = 100000


class MessageDecoder {
    
    var dataBuffer : Data = Data(capacity: BUFFER_SIZE)
    
    var msg: NetMessageBase? = nil;
    
    // 处理接收到的数据
    func processData(data: Data) -> [NetMessageBase] {
        
        dataBuffer.append(data);
        //data.removeAll()
        
        var messages: [NetMessageBase] = [NetMessageBase]()
        
        repeat {
            msg = tryParsePacket()
            if (msg != nil){
                messages.append( msg!)
            }
        } while(msg != nil)
        
        return messages
    }
    
    // 尝试解析包
    func tryParsePacket() -> NetMessageBase? {
        
        if (dataBuffer.count < 12){
            return nil
        }
        
        var start: UInt32 = extractUInt32(data: dataBuffer, pos: 0);
        let msgType = extractUInt32(data: dataBuffer, pos: 4)
        let msgLen = extractUInt32(data: dataBuffer, pos: 8)
        
        if (msgLen > (dataBuffer.count - 16)){
            return nil // data not enough for a message
        }
        
        let pos: Int = 12;
        
        let tmpData = dataBuffer.subdata(in: pos..<pos+Int(msgLen))
        let msg = decodeMsg(msgType: msgType, data: tmpData)
        //var msgData = String(data: dataBuffer.subdata(in: pos ..< pos + Int(msgLen)), encoding: String.Encoding.utf8)
        
        
        dataBuffer.removeSubrange(0 ..< Int(msgLen) + 16)
      
        
        print("msg: type=\(msgType) len=\(msgLen) data=\(String(describing: msg))")
        
        return msg;
    }
    
    func extractUInt32(data: Data, pos: Int) -> UInt32 {
        var value: UInt32 = 0
        let buffer = UnsafeMutableBufferPointer(start: &value, count: 1)
        
        _ = data.copyBytes(to: buffer, from: pos ..< pos + MemoryLayout<UInt32>.size);
        
        //var tmpData = data.subdata(in: pos..<pos+4)
        
        return value.bigEndian
    }
    
    func decodeMsg(msgType: UInt32, data: Data) -> NetMessageBase? {
        switch msgType {
        case 1:
            
                return try! JSONDecoder().decode(UpdateButtonsMessage.self, from: data)
        case 2:
            return try! JSONDecoder().decode(VolumeStateMessage.self, from: data)
        case 201:
            return try! JSONDecoder().decode(LoginStateMessage.self, from: data)
        default:
            return nil;
        }
    }
}
