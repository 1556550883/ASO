import UIKit
import Alamofire

class LoginView: UIViewController {
    
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var FirstView: UIView!
    @IBOutlet weak var secondView: UIView!
    
    @IBOutlet weak var thirdView: UIView!
    
    @IBOutlet weak var NS_Appid: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet var btn_verifycode: UIButton!
    @IBOutlet weak var appid: UIButton!
    @IBOutlet weak var btn_login: UIButton!
    var result:AnyObject!
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(false, animated:false)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        btn_verifycode.clipsToBounds = false
        btn_verifycode.layer.cornerRadius = 5.0
        btn_verifycode.layer.rasterizationScale = UIScreen.main.scale
        btn_verifycode.layer.contentsScale =  UIScreen.main.scale
        
        appid.clipsToBounds = false
        appid.layer.cornerRadius = 5.0
        appid.layer.rasterizationScale = UIScreen.main.scale
        appid.layer.contentsScale =  UIScreen.main.scale
        
        btn_login.clipsToBounds = false
        btn_login.layer.cornerRadius = 5.0
        btn_login.layer.rasterizationScale = UIScreen.main.scale
        btn_login.layer.contentsScale =  UIScreen.main.scale
        self.requestInfo()
        
        self.initIndicator();
        
        self.appid.isHidden = true;
        self.isLogin();
     
    }
    
    //判断是否需要登录
    func isLogin() -> Void {
        let userInfos = UserInfo.allUserFromDB();
        
        //判断是否需要登录
        if(userInfos != nil && userInfos?.count != 0){
            let s = userInfos?.first
            
            self.checkLoginStatus(userName: (s!["username"] as! String ), passWord: (s!["password"] as! String), appleid: (s!["appleid"] as! String));
        }
    }
    
    //检查appid开关
    func checkAppIdToggle() -> Void {
        
        self.btn_login.isHidden = true;
        self.titleView.isHidden = true;
        self.FirstView.isHidden = true;
        self.secondView.isHidden = true;
        self.thirdView.isHidden = true;
        
        let url = Constants.m_baseUrl + "app/duijie/getSystemParameter"
        Alamofire.request(url).responseJSON {response in
            NetCtr.parseResponse(view: self, response: response, successHandler:{
                result,obj,msg in
                let appleIdCheck = obj["appleIdCheck"]?.int32Value;
                let leastTaskTime:UInt = obj["leastTaskTime"]!.uintValue;
                let tongzhi = obj["notice"] as! String

                UserInfo.shared.setTongzhi(tongzhi: tongzhi)
                print(tongzhi)
                self.appid.isHidden = appleIdCheck! <= 0;
                UserInfo.shared.setCheckAppId(b: appleIdCheck! > 0);
                BackGroundTimer.shared.setExpTime(time: leastTaskTime);
                if(appleIdCheck! <= 0 || UserInfo.shared.m_strAppId != ""){
                     DispatchQueue.main.async(execute: {self.performSegue(withIdentifier: "user", sender: self)})
                }
                
            })
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.setHidesBackButton(true, animated:false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
      
        self.getDate()
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
     self.view.endEditing(true)
//        self.performSegue(withIdentifier: "user", sender: self)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onTxtTouch(_ sender: Any) {
        username.resignFirstResponder();
    }
    @IBAction func onPassWordTouch(_ sender: Any) {
        password.resignFirstResponder();
    }
    
//    @IBAction func onAppIdTouch(_ sender: Any) {
//        appid.resignFirstResponder();
//    }
    
    @IBAction func onAppIdClick(_ sender: Any) {
        
        if (UIPasteboard.general.string == nil)
        {
            CommonFunc.alert(view: self, title: "出错", content: "请先复制appid再点击！", okString: "好的")
        }
        else
        {
            let strappid = UIPasteboard.general.string;
            let titlestr = "appid:" + strappid!;
            self.appid.setTitle(titlestr, for:UIControlState.normal) //普通状态下的文字
//            self.appid.setTitle(titlestr, for:UIControlState.highlighted) //触摸状态下的文字
//            self.appid.setTitle(titlestr, for:UIControlState.disabled) //禁用状态下的文字
            self.appid.titleLabel!.text = UIPasteboard.general.string;
            
            UserInfo.shared.m_bCheckAppId = true
            print(UserInfo.shared.isCheckAppId())
            if (UserInfo.shared.isCheckAppId())
            {
                UserInfo.shared.setAppId(strAppId: strappid!);
                DispatchQueue.main.async(execute: {self.performSegue(withIdentifier: "user", sender: self)})
            }
        }
    }
    
    @IBAction func verifyCodeClick(_ sender: Any) {
        let userName = self.username.text
        let url = Constants.m_baseUrl + "app/user/send_msg?loginName=" + userName!
        
        Alamofire.request(url).responseJSON {response in
            
            NetCtr.parseResponse(view: self, response: response, successHandler:{
                result,obj,msg in
                if(result == 1){
                    self.btn_verifycode.alpha = 0.4
                    self.btn_verifycode.isEnabled = false
                }
            })
        }
    }
    
    //判断是否越狱
    func isJailBroken() -> Bool {
        let apps = ["/APPlications/Cydia.app","/APPlications/limera1n.app","/APPlications/greenpois0n.app","/APPlications/blackra1n.app","/APPlications/blacksn0w.app","/APPlications/redsn0w.app","/APPlications/Absinthe.app"]
        for app in apps {
            if FileManager.default.fileExists(atPath: app)
            {return true}
        }
        return false
    }
    
    @IBAction func login(_ sender: Any) {
        let userName = self.username.text
        let passWord = self.password.text
        let strappid = UserInfo.shared.m_strAppId;

        if(isJailBroken()){
            CommonFunc.alert(view: self, title: "警告！！", content: "越狱机器，无法使用！", okString: "ok");
            return;
        }
        
        if (userName == "" || passWord == "")
        {
            CommonFunc.alert(view: self, title: "登录失败！！", content: "请填写账号、密码！！！", okString: "去填写");
            return;
        }

        if(UserInfo.shared.isCheckAppId() && CommonFunc.validateEmail(email: strappid) == false)
        {
            CommonFunc.alert(view: self, title: "登录失败！！", content: "请填写正确的appid！！！", okString: "去填写");
            return;
        }

        checkLoginStatus(userName: userName!, passWord: passWord!, appleid: strappid)
    }
    
    func checkLoginStatus(userName:String, passWord:String, appleid:String) {
        play();
        

        let Apppp = self.NS_Appid.text
        
        
        let logintype = LoginType.ZHANGHAO.rawValue

        let url =  Constants.m_baseUrl + "app/user/login?loginName="+(userName) + "&password="+(passWord)+"&loginType=" + logintype + "&phoneSerialNumber=1C34D7A6-6248-4167-9010-725BE009A45A&ip=192.168.0.113" +  "&masterID="+Apppp!
        
        Alamofire.request(url).responseJSON {response in
            
            NetCtr.parseResponse(view: self, response: response, successHandler:{
                result,obj,msg in
                print(response);
                
                let userAppId = obj["userAppId"]?.stringValue;
                let loginName = obj["loginName"] as! String;
                let userNum = obj["userNum"] as! String;
                let score = obj["score"]?.floatValue;
                let scoreDay = obj["scoreDay"]?.floatValue;
                let scoreSum = obj["scoreSum"]?.floatValue;
                let userAppType = obj["userApppType"]?.floatValue;
                let phoneNum = obj["phoneNum"] as! String;
                let wechat = obj["weixin"] as! String;
                let zhifubao = obj["zhifubao"] as! String;
                let userNick = obj["userNick"] as! String;
                
//                wechat.replacingPercentEscapes(using: wechat)
                
//                wechat.utf8CString
                let mmmmm = wechat.removingPercentEncoding as! String
                
                print(wechat.removingPercentEncoding)
                
                let nnnnn = userNick.removingPercentEncoding as! String
                print(nnnnn)
                
                let weChatHeadImg = obj["weChatHeadUrl"] as! String;
                UserInfo.shared.setType(type: userAppType!)
                UserInfo.shared.setUserAppId(id:userAppId! )
                UserInfo.shared.setLoginName(name:loginName)
                UserInfo.shared.setPassWord(password:passWord)
                UserInfo.shared.setUserNum(userNum: userNum)
                UserInfo.shared.setScore(score: score!)
                UserInfo.shared.setScoreDay(scoreDay: scoreDay!)
                UserInfo.shared.setScoreSum(scoreSum: scoreSum!)
                UserInfo.shared.setAppId(strAppId: appleid)
                UserInfo.shared.setWeChat(weChat: mmmmm)
                UserInfo.shared.setPhonenum(phoneNum: phoneNum)
                UserInfo.shared.setWechatHeadImg(wechatHeadImg: weChatHeadImg)
                UserInfo.shared.setZhifubao(zhifubao: zhifubao)
                UserInfo.shared.setuserNick(userNick: nnnnn)
                if(userAppType == 2)
                {
                     DispatchQueue.main.async(execute: {self.performSegue(withIdentifier: "user", sender: self)})
                }else{
                     self.checkAppIdToggle();
                }
                
                if(SQLiteManager.instance.creatTable()){
                    print("创建表成功!")
                    UserInfo.shared.deleteSelfToDB()
                    UserInfo.shared.insertSelfToDB()
                }else{
                    print("创建表失败!")
                }

                let idfa = CommonFunc.getIDFA();
                let retrievedString: String? = KeychainWrapper.standard.string(forKey: "idfa_aso_Key")
                if(retrievedString == nil)
                {
                    KeychainWrapper.standard.set(idfa, forKey: "idfa_aso_Key")
                    UserInfo.shared.setMidfa(idfa:idfa)
                }else
                {
                    UserInfo.shared.setMidfa(idfa:retrievedString!)
                }
       
                let iosversion = UIDevice.current.systemVersion
                UserInfo.shared.setSysVersion(version: iosversion)
            })
            
            self.stop()
        }
    }
    
    func initIndicator()
    {
        activityIndicator.center = self.view.center;
        //在view中添加控件activityIndicator
        self.view.addSubview(activityIndicator)
    }
    
    func play()
    {
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false;
    }
    
    //菊花转动结束
    func stop()
    {
        activityIndicator.stopAnimating()
        self.view.isUserInteractionEnabled = true;
    }
    
    func requestInfo()
    {
        let aUrl = Constants.m_baseUrl + "/app/duijie/getSystemParameter";
        Alamofire.request(aUrl).responseJSON {
            response in
            NetCtr.parseResponse(view: self, response: response, successHandler:
                {
                    result,obj,msg in
                    print(obj,result,msg)
                    //                    self.tongzhi = obj["notice"] as! String
                    let LeastMoney = obj["leastForward"]?.floatValue;
                    UserInfo.shared.setLeastMoney(LeastMoney: LeastMoney!)
                    
                    let isTixian = obj["leastForward"]?.floatValue;
                    UserInfo.shared.setisTixian(isTixian: isTixian!)
                    
                    let shareUrl = obj["downloadUrl"] as! String
                    
                    UserInfo.shared.setShareUrl(ShareUrl: shareUrl)
                    
                    let tongzhi = obj["notice"] as! String
                    
                    UserInfo.shared.setTongzhi(tongzhi: tongzhi)
                    
                    let idfaCheck = obj["idfaCheck"] as! String
                    UserInfo.shared.setIdfaCheck(idfaCheck: idfaCheck)
            })
        }
    }
    
    func getDate(){
        let urlString = "http://m.baidu.com"
        
        let task = URLSession(configuration: URLSessionConfiguration.default).dataTask(with: URL(string: urlString)!) { (data, response, error) in
            
            
            if let httpresponse = response as? HTTPURLResponse {
                
                var dateString = httpresponse.allHeaderFields["Date"] as? String
                
                dateString = dateString?.substring(from: (dateString?.characters.index((dateString?.startIndex)!, offsetBy: 5))!)
                
                dateString = dateString?.substring(to: (dateString?.characters.index((dateString?.endIndex)!, offsetBy: -4))!)
                
                print(dateString)
                
                let datefmt = DateFormatter()
                datefmt.locale = Locale(identifier: "en_US")
                datefmt.dateFormat = "dd MMM yyyy HH:mm:ss"
                //                datefmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                //                datemmmmmm = datefmt.date(from: strNowTime)!
                
                let date = datefmt.date(from: dateString!)?.addingTimeInterval(60*60*8)
                print(date)
                
                let zone = NSTimeZone.system
                
                let inter = zone.secondsFromGMT(for: date!)
                let locadate = date?.addingTimeInterval(TimeInterval(inter))
                print(locadate)
                //                mm = locadate
//                self.datemmmmmm = locadate;
//                print(self.datemmmmmm)
                UserInfo.shared.setcurrentTime(currentTime: locadate!)
                print(UserInfo.shared.m_currentTime)
            }
            
        }
        task.resume()
   
    }
}

