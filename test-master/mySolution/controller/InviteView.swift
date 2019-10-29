//
//  InviteView.swift
//  mySolution
//
//  Created by 文高坡 on 2018/2/9.
//  Copyright © 2018年 bitse. All rights reserved.
//

import UIKit
import Alamofire

class InviteView: UIViewController {
    
    @IBOutlet weak var moneyText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(false, animated:false)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let button = UIButton(frame: CGRect(x:0,y:0,width:15,height:20))
        button.setBackgroundImage(UIImage(named:"push"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(pushback), for: UIControlEvents.touchUpInside)
        let item = UIBarButtonItem(customView:button)
        self.moneyText.keyboardType = UIKeyboardType.numberPad

        self.navigationItem.leftBarButtonItem = item
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @IBAction func tijiao(_ sender: Any) {
        let money  = moneyText.text

        if (!self.isPurnFloat(string: money!)) {
            CommonFunc.alert(view: self, title: "提示", content: "请输入金额数字！", okString: "知道了")

            return;
        }
        
        
        print(self.isPurnFloat(string: money!))
        if(UserInfo.shared.m_phonenum != "" && UserInfo.shared.m_weChat != ""){
//            if(Int(UserInfo.shared.m_isTixianL) > 0){
//                CommonFunc.alert(view: self, title: "提示", content: "已经有一条在提现了，稍后再说", okString: "OK")
//
//            }else{
            
            if(money?.isEmpty)!{
                return;
            }
            
            if(Int(UserInfo.shared.m_strScore) < Int(money!)!){
                CommonFunc.alert(view: self, title: "提示", content: "提现超过了总金额！", okString: "知道了")
            }else{
//                let money = String(UserInfo.shared.m_strScore);
                
                
                let url =  Constants.m_baseUrl + "app/userScore/putForward?userNum=" + UserInfo.shared.m_strUserNum + "&forward=" + money!
                
                Alamofire.request(url).responseJSON {response in
                    NetCtr.parseResponse(view: self, response: response, successHandler:{
                        result,obj,msg in
                        if(result == -1){
                            CommonFunc.alert(view: self, title: "提示", content: "余额不足", okString: "OK")

                        }else{
//                        CommonFunc.alert(view: self, title: "提示", content: "提现申请成功，请等待管理员审核！", okString: "OK")
                            
                            CommonFunc.alert(view: self, title: "提示！！", content: "提现申请成功，请等待管理员审核！", okString: "OK", okHandler: {
                                (UIAlertAction) in
                                self.navigationController?.popViewController(animated: true)
                                
                            }, exitString:"");
                        }
                    })
                }
//            }
            }
        }else{
            CommonFunc.alert(view: self, title: "提示", content: "请先绑定您的微信和手机号码！", okString: "知道了")
        }

        
        
    }
    func isPurnFloat(string: String) -> Bool {
        
        let scan: Scanner = Scanner(string: string)
        
        var val:Float = 0
        
        return scan.scanFloat(&val) && scan.isAtEnd
        
    }
    
    
    @objc func pushback() {
        self.navigationController?.popViewController(animated: true)
    }
}

