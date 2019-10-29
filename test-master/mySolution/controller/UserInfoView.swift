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
    @IBOutlet weak var addPayNum: UIButton!
    
    @IBOutlet weak var PayNum: UITextField!
    
    @IBOutlet weak var NamePeople: UITextField!
    @IBOutlet weak var AddName: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        let button = UIButton(frame: CGRect(x:0,y:0,width:15,height:20))
        button.setBackgroundImage(UIImage(named:"push"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(pushback), for: UIControlEvents.touchUpInside)
        let item = UIBarButtonItem(customView:button)
        
        self.navigationItem.leftBarButtonItem = item
        
        self.userID.text = UserInfo.shared.m_strUserAppId
        self.userID.isUserInteractionEnabled = false
        self.wechatNickName.isUserInteractionEnabled = false
        self.phoneNum.isUserInteractionEnabled = false
        self.PayNum.isUserInteractionEnabled = false
        self.NamePeople.isUserInteractionEnabled = false
        NotificationCenter.default.addObserver(self,selector: #selector(WXLoginSuccess(notification:)),name:NSNotification.Name(rawValue: "WXLoginSuccessNotification"),object: nil)
        //注册键盘回收空白处事件
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(UserInfoView.handleTap(sender:))))
        if(UserInfo.shared.m_weChat != ""){
            self.wechatNickName.text = UserInfo.shared.m_weChat
            self.addWechat.isHidden = true
        }
        
        if(UserInfo.shared.m_phonenum != ""){
            self.phoneNum.text =  UserInfo.shared.m_phonenum
//            self.phoneNum.isUserInteractionEnabled = true
            self.addPhoneNum.isHidden=true
            self.phoneNum.keyboardType = UIKeyboardType.numberPad
        }
        if(UserInfo.shared.m_zhifubao != ""){
            self.PayNum.text =  UserInfo.shared.m_zhifubao
//            self.PayNum.isUserInteractionEnabled = true
            self.addPayNum.isHidden=true
            self.PayNum.keyboardType = UIKeyboardType.numberPad
        }
        if(UserInfo.shared.m_struserNick != ""){
            self.NamePeople.text =  UserInfo.shared.m_struserNick
//            self.NamePeople.isUserInteractionEnabled = true
            self.AddName.isHidden=true
//            self.NamePeople.keyboardType = UIKeyboardType.numberPad
        }
    }
    @objc func pushback() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //添加手机号码收回键盘调用
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            phoneNum.resignFirstResponder()
            PayNum.resignFirstResponder()
            let PayForNum = self.PayNum.text;
            
            let userNick = NamePeople.text
            
            
            let phone = self.phoneNum.text;
            if(phone != UserInfo.shared.m_phonenum){
                UserInfo.shared.setPhonenum(phoneNum: phone!)
                let usernum = UserInfo.shared.m_strUserNum;
                let url =  Constants.m_baseUrl + "app/user/updateUserPhoneNum?phoneNum="+(phone!)+"&userNum="+(usernum)
                Alamofire.request(url).responseJSON {response in
                    NetCtr.parseResponse(view: self, response: response, successHandler:{
                        result,obj,msg in
                        CommonFunc.alert(view: self, title: "提示", content: "绑定手机号码成功！", okString: "OK")
                    })
                }
            }
            else if(PayForNum != UserInfo.shared.m_zhifubao ){
                UserInfo.shared.setZhifubao(zhifubao: PayForNum!)
                let usernum = UserInfo.shared.m_strUserNum;
                let url =  Constants.m_baseUrl + "app/user/updateUserAlipay?alipay="+(PayForNum!)+"&userNum="+(usernum)
                Alamofire.request(url).responseJSON {response in
                    NetCtr.parseResponse(view: self, response: response, successHandler:{
                        result,obj,msg in
                        CommonFunc.alert(view: self, title: "提示", content: "绑定支付宝成功！", okString: "OK")
                    })
                }

            }
            else if(userNick != UserInfo.shared.m_struserNick){
                UserInfo.shared.setuserNick(userNick:userNick!)
                let M_userNick = UserInfo.shared.m_struserNick
                
                let url =  Constants.m_baseUrl + "app/user/updateUserName?userNum=" + (UserInfo.shared.m_strUserNum) + "&userName=" + (userNick!)
                let  url_utf8 = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
                print(url_utf8)
                let urlutf8 = url_utf8.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
                Alamofire.request(urlutf8).responseJSON {response in
                    NetCtr.parseResponse(view: self, response: response, successHandler:{
                        result,obj,msg in
                        print(result,obj,msg)
                        CommonFunc.alert(view: self, title: "提示", content: "绑定用户名字成功后禁止更改哦！", okString: "OK")
                    })
                }
                
                
            }
        }
        self.view.endEditing(true);
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
    @objc func WXLoginSuccess(notification:Notification) {
        
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
            print(nickname,"_____",headimgurl)
//            WechatInfo.wechatInfo.setNickName(nickName: nickname)
//            WechatInfo.wechatInfo.setHeadimgurl(headimgurl: headimgurl)
//            UserInfo.shared.setWeChat(weChat: nickname)
//            UserInfo.shared.setWechatHeadImg(wechatHeadImg: headimgurl)
        
//            let queryItem1 = URLQueryItem(name: "weiXinName", value: WechatInfo.wechatInfo.m_nickName)
//            let queryItem2 = URLQueryItem(name: "userNum", value: UserInfo.shared.m_strUserNum)
//            let queryItem3 = URLQueryItem(name: "headImgUrl", value: WechatInfo.wechatInfo.m_headimgurl)
//            let url:String =  Constants.m_baseUrl + "app/user/updateUserWeiXin"
//            let urlCom = NSURLComponents(string: url)
//            urlCom?.queryItems = [queryItem1,queryItem2,queryItem3]
//            print(urlCom?.url)
//            //let urls = urlCom?.url
//            let requestWeiXinURL: URL = (urlCom?.url)!
            let nick_name = WechatInfo.wechatInfo.m_nickName.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
            
            print(nickname);
            WechatInfo.wechatInfo.setNickName(nickName: nickname)
            WechatInfo.wechatInfo.setHeadimgurl(headimgurl: headimgurl)
            let url =  Constants.m_baseUrl + "app/user/updateUserWeiXin?weiXinName=" + (WechatInfo.wechatInfo.m_nickName) + "&userNum=" + (UserInfo.shared.m_strUserNum) + "&headImgUrl=" + (WechatInfo.wechatInfo.m_headimgurl) + "&openID=" + (openid);
           let  url_utf8 = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
              print(url_utf8)
            let urlutf8 = url_utf8.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
            
            
            Alamofire.request(urlutf8).responseJSON {response in
                NetCtr.parseResponse(view: self, response: response, successHandler:{
                    result,obj,msg in
                    print(response)
                    if(result == 1){
                        CommonFunc.alert(view: self, title: "提示", content: "绑定微信成功！", okString: "OK")
                       
                        UserInfo.shared.setWeChat(weChat: nickname)
                        UserInfo.shared.setWechatHeadImg(wechatHeadImg: headimgurl)
                        DispatchQueue.main.async {
                            self.wechatNickName.text = nickname
                            self.addWechat.isHidden = true
                        }
                    }else{
                        CommonFunc.alert(view: self, title: "提示", content: msg, okString: "OK")
                    }
                })
            }
            /*
            
            
             let requestWeiXinURL: URL = URL.init(string: url_utf8)!
            let dataResult = try? Data.init(contentsOf: requestWeiXinURL, options: Data.ReadingOptions())
            let jsonResult2 = try! JSONSerialization.jsonObject(with: dataResult!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String,Any>
            print(jsonResult2)
//            self.updateWeiXin()
 */
//            DispatchQueue.main.async {
//                self.wechatNickName.text = nickname
//                self.addWechat.isHidden = true
//            }
        }
    }
    @IBAction func addPayNum(_ sender: Any) {
        CommonFunc.alert(view: self, title: "提示", content: "必须提现的支付宝账号哦！", okString: "继续绑定", okHandler: {
            (UIAlertAction) in
            self.PayNum.isUserInteractionEnabled = true
            self.addPayNum.isHidden=true
            self.PayNum.keyboardType = UIKeyboardType.numberPad
            // self.phoneNum.returnKeyType = UIReturnKeyType.done
            
            self.PayNum.becomeFirstResponder()
        }, exitString:"取消")
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
        print(url)
        print(WechatInfo.wechatInfo.m_nickName,WechatInfo.wechatInfo.m_headimgurl)
        Alamofire.request(url).responseJSON {response in
            NetCtr.parseResponse(view: self, response: response, successHandler:{
                result,obj,msg in
                CommonFunc.alert(view: self, title: "提示", content: "绑定微信成功！", okString: "OK")
            })
        }
        
        
}

    @IBAction func addPeopleName(_ sender: Any) {
        CommonFunc.alert(view: self, title: "提示", content: "绑定后就不能轻易修改了哦", okString: "继续绑定", okHandler: {
            (UIAlertAction) in
            self.NamePeople.isUserInteractionEnabled = true
            self.AddName.isHidden=true
//            self.NamePeople.keyboardType = UIKeyboardType.numberPad
            // self.phoneNum.returnKeyType = UIReturnKeyType.done
            
            self.NamePeople.becomeFirstResponder()
        }, exitString:"取消")
        
        
    }
}
