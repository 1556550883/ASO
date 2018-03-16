import UIKit
import Alamofire

class AdvDetail: UIViewController{
    
    var m_objData:AdvData!
    var m_schEntry:Timer? = nil;
    
    @IBOutlet weak var btn_url: UIButton!
    @IBOutlet weak var btn_chaxun: UIButton!
    @IBOutlet weak var img_icon: UIImageView!

    @IBOutlet weak var btn_open: UIButton!
    @IBOutlet weak var tf_money: UILabel!
    @IBOutlet weak var tf_des: UILabel!
    @IBOutlet weak var tf_name: UILabel!
    @IBOutlet weak var tf_time: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        //禁用会退键
//        self.navigationItem.hidesBackButton = true;
//        self.navigationItem.setHidesBackButton(true, animated: false)   
        self.navigationItem.setHidesBackButton(true, animated:false)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        btn_url.setTitle("关键字：" + m_objData.m_strName, for: .normal);
        btn_chaxun.setTitle("查询任务", for: .normal);
        btn_open.setTitle("打开软件", for: .normal);
        tf_des.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        tf_des.numberOfLines = 0
        
        tf_des.text = m_objData.m_strAdvDes
        
        tf_name.text = m_objData.m_strName;
        
        let url_str = Constants.m_baseUrl + "file/adver/img/" + m_objData.m_strImgUrl;
        let url = URL(string: url_str)
        img_icon.kf.setImage(with: url)
        tf_money.attributedText = CommonFunc.money(money: m_objData.m_strPrice)
        
        caculateTime();
        
        let item = UIBarButtonItem(title: "放弃",style: UIBarButtonItemStyle.plain, target: self, action: #selector(onGiveUpTaskClick))
        self.navigationItem.rightBarButtonItem = item
    }
    
    func caculateTime() {
        let endTime = CommonFunc.getNowTime();
        let interval = CommonFunc.getTimeInterval(create_time: m_objData.m_dateAdverDayStart!, end_time: endTime, limitTime: m_objData.m_timeLimit);
        if(interval == "0")
        {
            m_schEntry?.invalidate()
            let idfa = CommonFunc.getIDFA();
            let adverid = self.m_objData.m_strAdverId
            let url = Constants.m_baseUrl + "app/duijie/setTaskTimeout?idfa=" + idfa + "&adverId=" + adverid;
            
            Alamofire.request(url).responseJSON {response in
                NetCtr.parseResponse(view: self, response: response, successHandler: {
                   result,obj,msg in
                    CommonFunc.alert(view: self, title: "任务超时", content: "任务已自动被放弃！", okString: "好的", okHandler:{
                         action in
                         CommonFunc.goto(from: self, target: "give_up_task");
                    })
                })
            }
        }
        
        //定义富文本即有格式的字符串
        let attributedStrM : NSMutableAttributedString = NSMutableAttributedString()
        let strShengyushijian : NSAttributedString = NSAttributedString(string: "剩余时间：", attributes: [NSForegroundColorAttributeName:UIColor.lightGray,  NSFontAttributeName : UIFont.boldSystemFont(ofSize: 13.0)])
        let strTime : NSAttributedString = NSAttributedString(string:interval, attributes: [NSForegroundColorAttributeName : UIColor.red, NSFontAttributeName : UIFont.systemFont(ofSize: 13.0)])
        
        attributedStrM.append(strShengyushijian)
        attributedStrM.append(strTime)
        
        tf_time.attributedText = attributedStrM
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // 启用计时器，控制每秒执行一次tickDown方法
        m_schEntry = Timer.scheduledTimer(timeInterval: 1,
                                         target:self,selector:#selector(self.caculateTime),
                                         userInfo:nil,repeats:true)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        m_schEntry?.invalidate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onOpenClick(_ sender: Any) {
        CommonFunc.log(m_objData.m_strTaskType);
        if (CommonFunc.openApp(bundleid: m_objData.m_strBundleId))
        {
            let idfa = CommonFunc.getIDFA();
            let adverid = m_objData.m_strAdverId
            let tasktype = m_objData.m_strTaskType
            
            let url = Constants.m_baseUrl + "app/duijie/openApp?idfa=" + idfa + "&adverId=" + adverid + "&taskType=" + tasktype;
            
            
            Alamofire.request(url).responseJSON {response in
                NetCtr.parseResponse(view: self, response: response, successHandler: {
                    result,obj,msg in
                    BackGroundTimer.shared.startBackTick(sec: self.m_objData.m_iTimeRelease, bundleid:self.m_objData.m_strBundleId);
                })
            }
        }
        else
        {
            CommonFunc.alert(view: self, title: "打开失败！！", content: "程序打开失败！请确认已经下载该软件！", okString: "去下载", okHandler: {
            (UIAlertAction) in
                self.gotoAppStore();
            }, exitString: "取消");
        }
    }

    func gotoAppStore() {
        if m_objData.m_strUrl != "" {
            CommonFunc.gotoAppStore(urlString: m_objData.m_strUrl);
        }
        else
        {
            CommonFunc.gotoAppStore(urlString: "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/search");
        }
        
        UIPasteboard.general.string = m_objData.m_strName;
    }
    
    @IBAction func onUrlClick(_ sender: Any) {
        self.gotoAppStore();
    }
    
    func onGiveUpTaskClick() {
        let alertController = UIAlertController(title: "放弃任务", message: "您确定要放弃任务吗？", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "放弃", style: .default, handler: {
            action in
            print("点击了确定")
            let idfa = CommonFunc.getIDFA();
            let adverid = self.m_objData.m_strAdverId
            let url = Constants.m_baseUrl + "app/duijie/setTaskTimeout?idfa=" + idfa + "&adverId=" + adverid;

            Alamofire.request(url).responseJSON {response in
                 NetCtr.parseResponse(view: self, response: response, successHandler: {
                    result,obj,msg in
                    self.navigationController?.popViewController(animated: true)
                 })
            }
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func onChaxuClick(_ sender: Any)
    {
        let idfa = CommonFunc.getIDFA();
        let adverid = m_objData.m_strAdverId
        let adid = m_objData.m_strAdId
        let ip = CommonFunc.getPubIp();
        let url = Constants.m_baseUrl + "app/duijie/queryOneMission?adid=" + adid + "&idfa=" + idfa + "&ip=" + ip + "&adverId=" + adverid + "&userNum=" + UserInfo.shared.m_strUserNum;
        
        Alamofire.request(url).responseJSON {response in
            
            NetCtr.parseResponse(view: self, response: response, successHandler:{
                result, obj, msg in
                CommonFunc.alert(view: self, title: "任务进度", content: msg, okString: "继续做任务", okHandler: {
                    (UIAlertAction) in
                    
                     self.navigationController?.popViewController(animated: true)
                }, exitString:"取消")
            })
        }
    }
}
