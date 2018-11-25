//
//  ViewController.swift
//  Quicker
//
//  Created by CuiLiang on 2018/7/9.
//  Copyright © 2018年 CuiLiang. All rights reserved.
//

import UIKit
import CocoaAsyncSocket
import Alamofire
import AlamofireImage
import Kingfisher
import Font_Awesome_Swift


class ViewController: UIViewController, GCDAsyncSocketDelegate {
    
  
    
    let SCREEN_SIZE = UIScreen.main.bounds.size;
    
    // 按钮引用
    var buttonsDict = [Int: UIButton]();
    var lblProfile: UILabel? = nil;
    var muteButton: UIButton? = nil;
    var volumeSlider: UISlider? = nil;
    var stateLabel: UILabel? = nil;
    
    var pcIp = "192.168.2.248"
    var port: Int = 666
    var code = "Quicker"
    
    var isLoggedIn = false
    
    var uiCreated = false;
    
    var clientSocket: GCDAsyncSocket!
    
    let msgDecoder = MessageDecoder()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        createUi()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func createUi(){
        
        if (uiCreated){
            return;
        }else{
            uiCreated = true;
        }
        
        //
        print("创建UI")
        
            let window = UIApplication.shared.keyWindow
            let topPadding = window?.safeAreaInsets.top
            let bottomPadding = window?.safeAreaInsets.bottom
            //print("safe area \(self.view.safeAreaInsets.top)  \(self.view.safeAreaInsets.bottom)")
            //print("safe area \(topPadding)  \(bottomPadding)")
       
        
        
        // Do any additional setup after loading the view, typically from a nib.
        let defaults = UserDefaults.standard
        pcIp = defaults.string(forKey: "PcIp") ?? "192.168.2.100"
        port = defaults.integer(forKey: "PcPort")
        if (port < 1){
            port = 666
        }
        code = defaults.string(forKey: "PcCode") ?? "Quicker"
        
        
        
        
        
//
//        print("\(SCREEN_SIZE.width)*\(SCREEN_SIZE.height)")
//
//        let isIphoneX = SCREEN_SIZE.height == 812.0;
//        print("is iphonex:\(isIphoneX)")
        
        let startPos = topPadding!;
        
        let contentHeight =  SCREEN_SIZE.height -  topPadding! - bottomPadding!
        
        
        let btnWidth = (SCREEN_SIZE.width-3)/4;
        let btnHeight = (contentHeight - 70)/7;
        
        // global buttons
        for row in 0...2 {
            for col in 0...3{
                let frame = CGRect(x: 2 + btnWidth * CGFloat(col),
                                   y: startPos + CGFloat(row) * btnHeight,
                                   width: btnWidth-1,
                                   height: btnHeight-1)
                createButton(rect: frame,isGlobal:true, row:row, col:col)
                
            }
        }
        
        // label
        lblProfile = UILabel(frame: CGRect(x:10, y:startPos + 3*btnHeight + 5, width: 300, height: 20))
        lblProfile!.text = "profile"
        lblProfile!.textColor = UIColor.lightGray
        lblProfile?.font = UIFont.boldSystemFont(ofSize: 14)
        self.view.addSubview(lblProfile!)
        
        // context buttons
        
        let startPos2 = startPos + 3*btnHeight + 25;
        
        for row in 0...3 {
            for col in 0...3{
                let frame = CGRect(x: 2 + btnWidth * CGFloat(col),
                                   y: startPos2 + CGFloat(row) * btnHeight,
                                   width: btnWidth-1,
                                   height: btnHeight-1)
                createButton(rect: frame, isGlobal:false, row:row, col:col)
                
                
            }
        }
        
        //
        let startPos3 = startPos2 + 4*btnHeight + 5
        muteButton = UIButton(frame: CGRect(x: 20, y:startPos3, width: 30, height: 30))
        
        muteButton?.setFAIcon(icon: FAType.FAVolumeUp, iconSize:25, forState: UIControlState.normal)
        muteButton?.addTarget(self, action: #selector(muteBtnClicked(_:)), for: .touchUpInside)
        muteButton?.titleLabel?.setFAColor(color: UIColor.black)
        muteButton?.setTitleColor(Color.black, for: .normal)
        
        self.view.addSubview(muteButton!)
        
        volumeSlider = UISlider(frame: CGRect(x: 60, y: startPos3, width: 150, height:30))
        volumeSlider?.maximumValue = 100
        volumeSlider?.minimumTrackTintColor = UIColor.white
        volumeSlider?.maximumTrackTintColor = UIColor.black
        volumeSlider?.thumbTintColor = UIColor.white
        //volumeSlider?.addTarget(self, action: #selector(), for: <#T##UIControlEvents#>)
        volumeSlider?.addTarget(self, action: #selector(volumeValueChange(slider:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(volumeSlider!)
        
        //
        stateLabel = UILabel(frame: CGRect(x: 220, y: startPos3, width: 200, height: 30))
        stateLabel?.textColor = UIColor.gray
        self.view.addSubview(stateLabel!)
        
        //
        let configButton = UIButton(frame: CGRect(x: SCREEN_SIZE.width - 60,
                                                  y: startPos3,
                                                  width: 60,
                                                  height: 30))
        configButton.setTitleColor(Color.black, for: .normal)
        configButton.setFAIcon(icon: FAType.FACog, iconSize: 25, forState: .normal)
        configButton.addTarget(self, action: #selector(onConfigClick(_:)), for: .touchUpInside)
        self.view.addSubview(configButton)
        
        
        
        // client socket
        doConnect()
    }
    
    private func getButtonIndex(isGlobal:Bool, row: Int, col: Int) -> Int{
        return (isGlobal ? 0 : 1000000)
        + row * 1000
            + col;
    }
    
    // 创建一个按钮
    private func createButton(rect: CGRect,isGlobal:Bool, row: Int, col: Int){
        let btn = ImageTopButton(type: .custom);
        btn.frame = rect
        btn.backgroundColor = UIColor.lightGray
        
        var btnIndex = getButtonIndex(isGlobal: isGlobal, row: row, col: col)
        
        btn.tag = btnIndex;
        btn.setTitle(String(btn.tag), for: .normal)
        btn.addTarget(self, action: #selector(btnClicked(_:)), for: .touchUpInside)
        btn.addTarget(self, action: #selector(btnPressed(_:)), for: .touchDown)
        
        btn.imageView?.contentMode = .scaleAspectFit
        //btn.imageEdgeInsets = UIEdgeInsetsMake(30,30,10,10)
        //btn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, -10)
        //btn.titleLabel?.backgroundColor = UIColor.red
        //btn.titleLabel?.adjustsFontSizeToFitWidth = true;
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)//(ofSize: 14)
        btn.titleLabel?.textColor = UIColor.darkGray
        btn.titleLabel?.lineBreakMode = .byTruncatingTail
        btn.setTitleColor(UIColor.gray, for: .normal)
        //btn.setTitleColor(UIColor.blue, for: .highlighted)
        //btn.adjustsImageWhenHighlighted = true
        
        //btn.imageView?.backgroundColor = UIColor.green
        
        buttonsDict[btn.tag] = btn;
        
        self.view.addSubview(btn)
    }
    
    @objc func btnPressed(_ sender: UIButton){
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
        
    }
    
    @objc func btnClicked(_ sender: UIButton) {
        let btnIndex = sender.tag;
        print("button clicked:\(btnIndex)")
        
        
        
        sendButtonClickMessage(buttonIndex: btnIndex)
    }
    
    @objc func muteBtnClicked(_ sender: UIButton){
        let msg = ToggleMuteMessage()
        let data: Data = try! JSONEncoder().encode(msg)
        
        sendMessage(data, msgType: msg.MessageType)
    }
    
    @objc func volumeValueChange(slider: UISlider){
        print("volume change:\(slider.value)")
        
        let msg = UpdateVolumeMessage()
        msg.MasterVolume = Int(slider.value)
        let data: Data = try! JSONEncoder().encode(msg)
        
        sendMessage(data, msgType: msg.MessageType)
    }
    
    
    func doConnect(){
        isLoggedIn = false
        print("开始连接...")
        stateLabel?.text = "连接中..."
        closeConnection()
        
        clientSocket = GCDAsyncSocket()
        clientSocket.delegate = self;
        clientSocket.delegateQueue = DispatchQueue.global()
        do{
            try clientSocket.connect(toHost: pcIp, onPort: UInt16(port), withTimeout: 4.0)
            print("after call connect()...")
            // try clientSocket.connect(toHost: pcIp, onPort: UInt16(port))
        }catch{
            print("连接 error")
            
        }
    }
    
    func updateState(state: String){
        // 主界面UI显示数据
        DispatchQueue.main.async {
            self.stateLabel?.text = state;
        }
    }
   
    
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        print("连接成功")
        
        let msg = DeviceLoginMessage()
        msg.ConnectionCode = code
        msg.Version = "0.0.1" //todo
        msg.DeviceName = "ios" //todo
        let data: Data = try! JSONEncoder().encode(msg)
        
        sendMessage(data, msgType: msg.MessageType)
        
        updateState(state:"登录中")
        clientSocket.readData(withTimeout: -1, tag: 0)
    }
    
    
    func closeConnection(){
        if (clientSocket != nil && clientSocket.isConnected){
            clientSocket.disconnect()
        }
        
        clientSocket = nil
    }
    
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        //stateLabel?.text = "未连接"
         updateState(state:"未连接")
        isLoggedIn = false
        print("与pc断开 \(String(describing: err))")
        
        //self.clientSocket.delegate = nil
        //self.clientSocket = nil
       
        if (err != nil){
            // 如果是主动断开的，会重复进入配置页面
            DispatchQueue.main.async {
                if (self.clientSocket.isConnected == false){
                     self.openConfigWindow()
                }
               
            }
        }
        
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        // 获取客户端发来的数据，吧NSData转NSString
        
        //let readClientDaaString: NSString? = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)
        print("--data received--\(data.count)")
        //print(readClientDaaString)
        
        let messages = msgDecoder.processData(data: data)
        
        // 主界面UI显示数据
        DispatchQueue.main.async {
            if (messages.count > 0){
                for msg in messages {
                    self.processPcMessage(message: msg)
                }
            }
        }
        
        // 准备读取下次数据
        clientSocket.readData(withTimeout: -1, tag: 0)
        
    }
    
    fileprivate func sendMessage(_ data: Data, msgType: Int) {
       
        
        
        
        
        if (clientSocket == nil || clientSocket.isConnected == false){
            print("socket not connected!!")
            return
        }
        
        
        var msgData = Data.init(count: 0);
        let startFlag = 0xFFFFFFFF;
        
        
        addUInt32ToData(data: &msgData, value: UInt32(startFlag))
        addUInt32ToData(data: &msgData, value: UInt32(msgType))
        addUInt32ToData(data: &msgData, value: UInt32(data.count))
        msgData.append(data)
        addUInt32ToData(data: &msgData, value: UInt32(0x00000000))
        
        // send message
        clientSocket.write(msgData, withTimeout: -1, tag: 0)
    }
    
    func sendButtonClickMessage(buttonIndex: Int){
        //clientSocket.write(data: message, withTimeout: -1, tag: 0)
        let msg = ButtonClickedMessage();
        msg.ButtonIndex = buttonIndex
        let data: Data = try! JSONEncoder().encode(msg)
        
        sendMessage(data, msgType:  msg.MessageType)
    }
    
    private func addUInt32ToData(data: inout Data, value: UInt32){
        var beValue = value.bigEndian
        
        data.append(UnsafeBufferPointer(start: &beValue, count:1))
    }
    
    
    func processPcMessage(message: NetMessageBase){
        
        
        if (message is UpdateButtonsMessage){
            let msg = message as! UpdateButtonsMessage
            lblProfile!.text = msg.ProfileName
            
            for btn in msg.Buttons!{
                let button = buttonsDict[btn.Index!]
                
                button?.isEnabled = btn.IsEnabled!
                
                if (btn.IsEnabled!){
                    button?.backgroundColor = UIColor.white
                }else{
                    button?.backgroundColor = UIColor.lightGray
                }
                
                button?.setTitle(btn.Label, for: .normal)
                if (btn.IconFileName != nil && !btn.IconFileName!.isEmpty){
                    
                    let url = URL(string: btn.IconFileName!)
                    
                    button?.kf.setImage(with: url, for: .normal)
                    
                    //                    print("loadding image:\(btn.IconFileName)")
                    //                    let url = URL(string: btn.IconFileName!)
                    
                    // button?.af_setImage(for: .normal, url: url!)
                    
                    
                    //                    DispatchQueue.global().async{
                    //                        let data = try? Data(contentsOf: url!)
                    //                        DispatchQueue.main.async {
                    //                            button?.setImage(UIImage(data:data!)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), for: UIControlState.normal)
                    //                        }
                    //                    }
                    
                    
                }else{
                    button?.setImage(nil, for: .normal)
                }
            }
        }else if message is VolumeStateMessage {
            let msg = message as! VolumeStateMessage
            if (msg.Mute){
                muteButton?.setFAIcon(icon: FAType.FAVolumeOff, iconSize:25, forState: .normal)
            }else if msg.MasterVolume > 50 {
                 muteButton?.setFAIcon(icon: FAType.FAVolumeUp,  iconSize:25,forState: .normal)
            }else {
                 muteButton?.setFAIcon(icon: FAType.FAVolumeDown, iconSize:25, forState: .normal)
            }
            
            volumeSlider?.isHidden = msg.Mute
            
            volumeSlider?.setValue(Float(msg.MasterVolume), animated: true)
        }else if message is LoginStateMessage {
            let msg = message as! LoginStateMessage
            if (msg.IsLoggedIn){
                updateState(state: "登录成功")
                
                //var msg = CommandMessage()
                //msg.Command = "RESEND_STATE"
            }else{
                updateState(state: "登录失败，请检查参数是否正确。")
                openConfigWindow()
            }
        }
    }
    
    //let configView = ConfigViewController()
    //configView.ip = pcIp
    //configView.port = port
    //present(configView, animated: true, completion: nil)
    
    fileprivate func openConfigWindow() {
        let configView = storyboard?.instantiateViewController(withIdentifier: "ConfigView") as! ConfigViewController
        
        //let configView = ConfigViewController()
        configView.ip = pcIp
        configView.port = port
        configView.code = code
        present(configView, animated: true, completion: nil)
    }
    
    @IBAction func onConfigClick(_ sender: Any) {
        openConfigWindow()
    }
    
    
    func changeAddr(ip: String, port: Int, code: String){
        self.pcIp = ip;
        self.port = port;
        self.code = code;
        
        let defaults = UserDefaults.standard
        defaults.set(pcIp, forKey: "PcIp")
        defaults.set(port, forKey: "PcPort")
        defaults.set(code, forKey: "PcCode")
        
        doConnect()
    }
}

