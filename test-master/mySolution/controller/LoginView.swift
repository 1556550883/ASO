import UIKit
import Alamofire

class LoginView: UIViewController {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet var btn_verifycode: UIButton!
    @IBOutlet weak var appid: UIButton!
    @IBOutlet weak var btn_login: UIButton!
    var result:AnyObject!
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initIndicator();
        self.checkAppIdToggle();
    }
    
    //检查appid开关
    func checkAppIdToggle() -> Void {
        
        self.btn_login.isHidden = true;
        
        let url = Constants.m_baseUrl + "app/duijie/getSystemParameter"
        Alamofire.request(url).responseJSON {response in
            NetCtr.parseResponse(view: self, response: response, successHandler:{
                result,obj,msg in
                let appleIdCheck = obj["appleIdCheck"]?.int32Value;
                let leastTaskTime:UInt = obj["leastTaskTime"]!.uintValue;
                
                self.appid.isHidden = appleIdCheck! <= 0;
                UserInfo.shared.setCheckAppId(b: appleIdCheck! > 0);
                BackGroundTimer.shared.setExpTime(time: leastTaskTime);
                
                let userInfos = UserInfo.allUserFromDB();
                
                //判断是否需要登录
                if(userInfos != nil && userInfos?.count != 0){
                    let s = userInfos?.first
                    
                    if(UserInfo.shared.isCheckAppId()){
                        if(s!["appleid"] as! String != ""){
                            self.checkLoginStatus(userName: (s!["username"] as! String ), passWord: (s!["password"] as! String), appleid: (s!["appleid"] as! String));
                        }
                    }else{
                         self.checkLoginStatus(userName: (s!["username"] as! String ), passWord: (s!["password"] as! String), appleid: (s!["appleid"] as! String));
                    }
                }

                //login按钮显示
                self.btn_login.isHidden = false;
            })
            
        }
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
            
            if (UserInfo.shared.isCheckAppId())
            {
                UserInfo.shared.setAppId(strAppId: strappid!);
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
    
    @IBAction func login(_ sender: Any) {
        let userName = self.username.text
        let passWord = self.password.text
        let strappid = UserInfo.shared.m_strAppId;
        
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
        let logintype = LoginType.ZHANGHAO.rawValue
        let url =  Constants.m_baseUrl + "app/user/login?loginName="+(userName)+"&password="+(passWord)+"&loginType=" + logintype + "&phoneSerialNumber=1C34D7A6-6248-4167-9010-725BE009A45A&ip=192.168.0.113"
        Alamofire.request(url).responseJSON {response in
            
            NetCtr.parseResponse(view: self, response: response, successHandler:{
                result,obj,msg in
                let userAppId = obj["userAppId"]?.stringValue;
                let loginName = obj["loginName"] as! String;
                let userNum = obj["userNum"] as! String;
                let score = obj["score"]?.floatValue;
                let scoreDay = obj["scoreDay"]?.floatValue;
                let scoreSum = obj["scoreSum"]?.floatValue;
                UserInfo.shared.setUserAppId(id:userAppId! )
                UserInfo.shared.setLoginName(name:loginName)
                UserInfo.shared.setPassWord(password:passWord)
                UserInfo.shared.setUserNum(userNum: userNum)
                UserInfo.shared.setScore(score: score!)
                UserInfo.shared.setScoreDay(scoreDay: scoreDay!)
                UserInfo.shared.setScoreSum(scoreSum: scoreSum!)
                UserInfo.shared.setAppId(strAppId: appleid)
                
                DispatchQueue.main.async(execute: {self.performSegue(withIdentifier: "user", sender: self)})
                
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
}

