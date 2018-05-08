//
//  UserInfoView.swift
//  mySolution
//
//  Created by 文高坡 on 2018/2/11.
//  Copyright © 2018年 bitse. All rights reserved.
//

import UIKit
import Alamofire

class UserInfoView: UIViewController {
    @IBOutlet weak var userID: UITextField!
    @IBOutlet weak var addWechat: UIButton!
    
    @IBOutlet weak var addPhoneNum: UIButton!
    @IBOutlet weak var phoneNum: UITextField!
    @IBOutlet weak var wechatNickName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userID.text = UserInfo.shared.m_strUserAppId
        self.userID.isUserInteractionEnabled = false
        self.wechatNickName.isUserInteractionEnabled = false
        self.phoneNum.isUserInteractionEnabled = false
        NotificationCenter.default.addObserver(self,selector: #selector(WXLoginSuccess(notification:)),name:NSNotification.Name(rawValue: "WXLoginSuccessNotification"),object: nil)
        //注册键盘回收空白处事件
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(UserInfoView.handleTap(sender:))))
        if(UserInfo.shared.m_weChat != ""){
            self.wechatNickName.text = UserInfo.shared.m_weChat
            self.addWechat.isHidden = true
        }
        
        if(UserInfo.shared.m_phonenum != ""){
            self.phoneNum.text =  UserInfo.shared.m_phonenum
            self.phoneNum.isUserInteractionEnabled = true
            self.addPhoneNum.isHidden=true
            self.phoneNum.keyboardType = UIKeyboardType.numberPad
        }
    }
    
    //添加手机号码收回键盘调用
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            phoneNum.resignFirstResponder()
            let phone = self.phoneNum.text;
            if(phone != UserInfo.shared.m_phonenum){
                UserInfo.shared.setPhonenum(phoneNum: phone!)
                let usernum = UserInfo.shared.m_strUserNum;
                let url =  Constants.m_baseUrl + "app/user/updateUserPhoneNum?phoneNum="+(phone!)+"&userNum="+(usernum)
                Alamofire.request(url).responseJSON {response in
                    NetCtr.parseResponse(view: self, response: response, successHandler:{
                        result,obj,msg in
                        //CommonFunc.alert(view: self, title: "提示", content: "绑定手机号码成功！", okString: "OK")
                    })
                }
            }
        }
        sender.cancelsTouchesInView = false
    }
    
    @IBAction func AddWeChat(_ sender: Any) {
        let urlStr = "weixin://"
        if UIApplication.shared.canOpenURL(URL.init(string: urlStr)!) {
            let red = SendAuthReq.init()
            red.scope = "snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact"
            red.state = "HappyZhuanAPP"
            WXApi.send(red)
        }else{
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL.init(string: "http://weixin.qq.com/r/qUQVDfDEVK0rrbRu9xG7")!, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(URL.init(string: "http://weixin.qq.com/r/qUQVDfDEVK0rrbRu9xG7")!)
            }
        }
    }
    
    /**  微信通知  */
    func WXLoginSuccess(notification:Notification) {
        
        let code = notification.object as! String
        let WX_APPID = "wx976c46a725b070f6"
        let WX_APPSecret = "1b86568c4efe3c8998e58758338989eb"
        let requestUrl = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=\(WX_APPID)&secret=\(WX_APPSecret)&code=\(code)&grant_type=authorization_code"
        
        DispatchQueue.global().async {
            
            let requestURL: URL = URL.init(string: requestUrl)!
            let data = try? Data.init(contentsOf: requestURL, options: Data.ReadingOptions())
            
            DispatchQueue.main.async {
                let jsonResult = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String,Any>
                let openid: String = jsonResult["openid"] as! String
                let access_token: String = jsonResult["access_token"] as! String
                self.getUserInfo(openid: openid, access_token: access_token)
            }
        }
    }
    
    /**  获取用户信息  */
    func getUserInfo(openid:String,access_token:String) {
        let requestUrl = "https://api.weixin.qq.com/sns/userinfo?access_token=\(access_token)&openid=\(openid)"
        DispatchQueue.global().async {
            
            let requestURL: URL = URL.init(string: requestUrl)!
            let data = try? Data.init(contentsOf: requestURL, options: Data.ReadingOptions())
            
            let jsonResult = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String,Any>
            let nickname = jsonResult["nickname"] as! String
            //let unionid = jsonResult["unionid"] as! String
            let headimgurl = jsonResult["headimgurl"] as! String
            WechatInfo.wechatInfo.setNickName(nickName: nickname)
            WechatInfo.wechatInfo.setHeadimgurl(headimgurl: headimgurl)
            UserInfo.shared.setWeChat(weChat: nickname)
            UserInfo.shared.setWechatHeadImg(wechatHeadImg: headimgurl)
        
//            let queryItem1 = URLQueryItem(name: "weiXinName", value: WechatInfo.wechatInfo.m_nickName)
//            let queryItem2 = URLQueryItem(name: "userNum", value: UserInfo.shared.m_strUserNum)
//            let queryItem3 = URLQueryItem(name: "headImgUrl", value: WechatInfo.wechatInfo.m_headimgurl)
//            let url:String =  Constants.m_baseUrl + "app/user/updateUserWeiXin"
//            let urlCom = NSURLComponents(string: url)
//            urlCom?.queryItems = [queryItem1,queryItem2,queryItem3]
//            print(urlCom?.url)
//            //let urls = urlCom?.url
//            let requestWeiXinURL: URL = (urlCom?.url)!
            let url =  Constants.m_baseUrl + "app/user/updateUserWeiXin?weiXinName=" + (WechatInfo.wechatInfo.m_nickName) + "&userNum=" + (UserInfo.shared.m_strUserNum) + "&headImgUrl=" + (WechatInfo.wechatInfo.m_headimgurl)
            let  url_utf8 = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
              print(url_utf8)
             let requestWeiXinURL: URL = URL.init(string: url_utf8)!
            let dataResult = try? Data.init(contentsOf: requestWeiXinURL, options: Data.ReadingOptions())
            let jsonResult2 = try! JSONSerialization.jsonObject(with: dataResult!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String,Any>
            print(jsonResult2)
            DispatchQueue.main.async {
                self.wechatNickName.text = nickname
                self.addWechat.isHidden = true
            }
        }
    }

    @IBAction func addPhoneNum(_ sender: Any) {
        CommonFunc.alert(view: self, title: "提示", content: "必须使用和微信绑定的同一个手机号", okString: "继续绑定", okHandler: {
            (UIAlertAction) in
            self.phoneNum.isUserInteractionEnabled = true
            self.addPhoneNum.isHidden=true
            self.phoneNum.keyboardType = UIKeyboardType.numberPad
           // self.phoneNum.returnKeyType = UIReturnKeyType.done

            self.phoneNum.becomeFirstResponder()
        }, exitString:"取消")
    }
    
    func updateWeiXin(){
        let url =  Constants.m_baseUrl + "app/user/updateUserWeiXin?weiXinName=" + (WechatInfo.wechatInfo.m_nickName) + "&userNum=" + (UserInfo.shared.m_strUserNum) + "&headImgUrl=" + (WechatInfo.wechatInfo.m_headimgurl)
        Alamofire.request(url).responseJSON {response in
            NetCtr.parseResponse(view: self, response: response, successHandler:{
                result,obj,msg in
                CommonFunc.alert(view: self, title: "提示", content: "绑定微信成功！", okString: "OK")
            })
        }
    }
}

