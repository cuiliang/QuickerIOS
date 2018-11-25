//
//  ConfigViewController.swift
//  Quicker
//
//  Created by CuiLiang on 2018/7/13.
//  Copyright © 2018年 CuiLiang. All rights reserved.
//

import UIKit
import Font_Awesome_Swift

class ConfigViewController: UIViewController {

    @IBOutlet weak var btnScanQrcode: UIButton!
    @IBOutlet weak var txtIp: UITextField!
    
    @IBOutlet weak var txtPort: UITextField!
    
    @IBOutlet weak var txtCode: UITextField!
    
    
    public var ip :String = ""
    public var port: Int = 0
    public var code: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtIp.text = ip
        txtPort.text = String(port)
        txtCode.text = code
        
        btnScanQrcode.setFAIcon(icon: FAType.FAQrcode, iconSize: 25, forState: .normal)
        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onOkClicked(_ sender: Any) {
        
        if let presenter = presentingViewController as? ViewController{
            presenter.changeAddr(ip: txtIp!.text!, port: Int(txtPort!.text!)!, code: txtCode!.text!)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onCancelClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func scanQrcode(_ sender: Any) {
        var scanView = ScannerViewController()
        present(scanView, animated: true, completion: nil)
    }
    
    public func setScanResult(scaned: String){
        if (scaned.starts(with: "PB:")){
            var parts = scaned.components(separatedBy: "\n")
            if (parts.count >= 4){
                txtIp.text = parts[1]
                txtPort.text = parts[2]
                txtCode.text = parts[3]
            }
        }else{
            //TODO: show error
        }
    }
}
