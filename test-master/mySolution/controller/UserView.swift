//
//  UserView.swift
//  mySolution
//
//  Created by 战神 on 2017/6/4.
//  Copyright © 2017年 bitse. All rights reserved.
//

import UIKit
import Alamofire

class UserView: UIViewController,UITableViewDelegate,UIScrollViewDelegate
{
    var SWidth:CGFloat = 0.0;
    
    @IBOutlet weak var TitleImage: UIImageView!
    @IBOutlet var user_view: UIView!
    @IBOutlet var user_task: UIButton!
    @IBOutlet var tf_userid: UITextField!
    @IBOutlet var scoreDay: UITextField!
    @IBOutlet var score: UITextField!
    @IBOutlet var scoreSum: UITextField!
    @IBOutlet weak var inviteClick: UIButton!
    @IBOutlet weak var headImg: UIImageView!
    @IBOutlet weak var user_view_Width: NSLayoutConstraint!
    
    @IBOutlet weak var tixian: UIButton!
    
    
    
    
    var myQueue:DispatchQueue?
    
    var scrollView: UIScrollView!
    var timer:Timer?
    
    var tongzhi:String = ""
    
    
//#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
//public let IS_IPHONE_5 = ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
    
    //菊花
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        user_view.clipsToBounds = false
        user_view.layer.cornerRadius = 10.0
        user_view.layer.rasterizationScale = UIScreen.main.scale
        user_view.layer.contentsScale =  UIScreen.main.scale
        user_view.layer.shadowColor = UIColor.gray.cgColor
        user_view.layer.shadowOffset = CGSize.zero
        user_view.layer.shadowRadius = 10.0
        user_view.layer.shadowOpacity = 0.5
        
//        headImg.backgroundColor = UIColor.red
        headImg.clipsToBounds = false
        headImg.layer.cornerRadius = 20.0
        headImg.layer.rasterizationScale = UIScreen.main.scale
        headImg.layer.contentsScale =  UIScreen.main.scale
//
        tixian.clipsToBounds = false
        tixian.layer.cornerRadius = 5.0
        tixian.layer.rasterizationScale = UIScreen.main.scale
        tixian.layer.contentsScale =  UIScreen.main.scale
        
        user_view.frame = CGRect(x:100,y:24,width:SCREEN_WIDTH - 48,height:200)
        
        
        
        self.shareVc.itemClickBlock = { (index) in
            if index == 0 {
                self.sendWXContentUser()
            }else if index == 1{
                self.sendWXContentFriend()

            }

        }
        //       x 295:h:230
        
        scrollView = UIScrollView();
        scrollView.frame = CGRect(x: 0, y: 200, width: 295, height: 30);
//        scrollView.backgroundColor = UIColor.red;
        let tongzhi = UserInfo.shared.m_tongzhi;
        print(tongzhi)
        let width = tongzhi.size(withAttributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 13)]).width
        print(width)
        SWidth = width
        scrollView.contentSize = CGSize(width: width*2, height: 30)
        scrollView.alwaysBounceHorizontal = false;
        scrollView.contentOffset = CGPoint(x:width,y:0)
 
        var i = 0;
        for i in 0..<3{
            let label = UILabel()
            label.text = tongzhi
            label.textColor = UIColor.red;
            label.font = UIFont.systemFont(ofSize: 12)
            label.frame = CGRect(x: i * Int(width), y: 0, width: Int(width), height: 30)
            self.scrollView.addSubview(label);
        }
        scrollView.delegate = self;
        user_view.addSubview(scrollView);
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector:#selector(change), userInfo: nil, repeats: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.setHidesBackButton(true, animated:false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    override func viewDidAppear(_ animated: Bool)
    {
        self.navigationItem.setHidesBackButton(true, animated:false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        if(UserInfo.shared.m_weChat != ""){
            self.tf_userid.text = UserInfo.shared.m_weChat;
        }else{
             self.tf_userid.text = UserInfo.shared.m_strLoginName
        }
        self.tf_userid.isUserInteractionEnabled = false
        self.requestInfo();
        
        if(UserInfo.shared.m_weChatHeadImg != ""){
            let url = URL(string: UserInfo.shared.m_weChatHeadImg)
            self.headImg.kf.setImage(with: url)
        }
    }
    
    @IBAction func inviteClick(_ sender: Any) {
        
//        self.shareVc.show()

        CommonFunc.alert(view: self, title: "没有分享了！！", content: "", okString: "知道了");
        
        
        //self.performSegue(withIdentifier: "ToInvite", sender: self)
//        self.send WXContentFriend()
      
//        self.sendWXContentUser()
        //sendWXContentUser()
//        let req = SendMessageToWXReq()
//        req.text = "happy赚"
//        req.bText=true
//        req.scene=1
//        WXApi.send(req)
        
//        let myWebsite = NSURL(string:"http://www.google.com/")
//        let img: UIImage =  UIImage(named:"Icon")!
//
//        guard let url = myWebsite else {
//            print("nothing found")
//            return
//        }
//
//        let shareItems:Array = [img,url]
//        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
//        activityViewController.excludedActivityTypes = [UIActivityType.print, UIActivityType.postToWeibo, UIActivityType.copyToPasteboard, UIActivityType.addToReadingList, UIActivityType.postToVimeo]
//        self.present(activityViewController, animated: true, completion: nil)
    }
    
    //分享朋友圈
    func sendWXContentFriend() {
        var message:WXMediaMessage = WXMediaMessage()
        let appID:String = UserInfo.shared.m_strUserAppId

        message.title = "happy赚：" + ("点击下载" as! String) + "happy赚的分享人ID:"+appID
        
        
        
        message.description="happy赚的分享人ID:"+appID
        message.setThumbImage(UIImage(named: "icon.png"));
        var ext:WXWebpageObject = WXWebpageObject();
        ext.webpageUrl = UserInfo.shared.m_shareUrl;
        message.mediaObject = ext
        message.mediaTagName = "happy赚"
        var req = SendMessageToWXReq()
        req.scene = 1
        req.text = "happy赚：" + ("点击下载" as! String)
        req.bText = false
        req.message = message
        WXApi.send(req);
    }
    
    func sendWXContentUser() {//分享给朋友！！
        var message:WXMediaMessage = WXMediaMessage()
        let appID:String = UserInfo.shared.m_strUserAppId

        message.title = "happy赚：" + ("点击下载" as! String)
        

        message.description="happy赚的分享人ID:"+appID
        //这两步是把图片缩小的
        //var nowUIImage:UIImage = self.getNowUIImage();
        //var endUIImage:UIImage = viewClass.OriginImage(nowUIImage, ewidth: 100, eheight: 100)
        //message.setThumbImage(endUIImage);
        var ext:WXWebpageObject = WXWebpageObject();
        ext.webpageUrl = UserInfo.shared.m_shareUrl;
        message.mediaObject = ext
        var resp = GetMessageFromWXResp()
        resp.message = message
        WXApi.send(resp);
    }
    
    @IBAction func playTaskClick(_ sender: Any){

//            self.getDate()

//        self.navigationController?.pushViewController(AdvView(), animated: true)
//        DispatchQueue.global(qos: .default).asyncAfter(deadline: DispatchTime.now() + 1.0) {
//            self.performSegue(withIdentifier: "task", sender: self)
//        print("fjkkfkffjkf")
//        }
            self.performSegue(withIdentifier: "task", sender: self)


    }
    
    func refreshView()
    {
        scoreDay.text = String(format: "%.1f元", UserInfo.shared.m_strScoreDay);
        score.text = String(format: "%.1f元", UserInfo.shared.m_strScore) ;
        scoreSum.text = String(format: "%.1f元", UserInfo.shared.m_strScoreSum);
        self.scoreDay.isUserInteractionEnabled = false
        self.score.isUserInteractionEnabled = false
        self.scoreSum.isUserInteractionEnabled = false
    }
    
    func requestInfo()
    {
        let userNum = UserInfo.shared.m_strUserNum
        let url = Constants.m_baseUrl + "app/userScore/getScore?userNum=" + userNum;
        Alamofire.request(url).responseJSON
            {
                response in
                NetCtr.parseResponse(view: self, response: response, successHandler:
                    {
                        result,obj,msg in
                        let score = obj["score"]?.floatValue
                        let scoreSum = obj["scoreSum"]?.floatValue
                        let scoreDay = obj["scoreDay"]?.floatValue
//                        let type = obj["type"]?.floatValue
                        
                        UserInfo.shared.setScore(score: score!);
                        UserInfo.shared.setScoreSum(scoreSum: scoreSum!);
                        UserInfo.shared.setScoreDay(scoreDay: scoreDay!)
//                        UserInfo.shared.setType(type: type!);
                        
                        self.refreshView()
                })
        }
        
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
                    self.refreshView()
//                    var i = 0;
//                    for i in 0..<3{
//                        let label = UILabel()
//                        label.text = self.tongzhi
//                        label.textColor = UIColor.red;
//                        label.font = UIFont.systemFont(ofSize: 12)
//                        label.frame = CGRect(x: i * 295, y: 0, width: 295, height: 30)
//                       self.scrollView.addSubview(label);
//                    }


            })
        }
 
        
        
        
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onDetailClick(_ sender: Any)
    {
        self.performSegue(withIdentifier: "detail", sender: self)
    }
    
    @IBAction func onUserDetailClick(_ sender: Any) {
        self.performSegue(withIdentifier: "userDetail", sender: self)
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
//        let destinationView = segue.destination as! AdvDetail
//        
//        destinationView.m_objData = m_objCurData
    }
    
    
    @IBAction func onTiXianClick(_ sender: Any)
    {
        if(UserInfo.shared.m_phonenum != "" && UserInfo.shared.m_weChat != ""){
        if(UserInfo.shared.m_phonenum != "" && UserInfo.shared.m_weChat != ""){
            if(UserInfo.shared.m_strScore <= UserInfo.shared.m_strLeastMoney){
                CommonFunc.alert(view: self, title: "提示", content: "余额必须高于"+String(UserInfo.shared.m_strLeastMoney)+"元才可提现！", okString: "知道了")
            }else{
                
                
                self.performSegue(withIdentifier: "Tixian", sender: self)

                
                
            }
        }
    }else{
        CommonFunc.alert(view: self, title: "提示", content: "请先绑定您的微信和手机号码！", okString: "知道了")
        }
        
        
        
        
        
//        if(UserInfo.shared.m_phonenum != "" && UserInfo.shared.m_weChat != ""){
//            if(UserInfo.shared.m_strScore <= UserInfo.shared.m_strLeastMoney){
//                CommonFunc.alert(view: self, title: "提示", content: "余额必须高于"+String(UserInfo.shared.m_strLeastMoney)+"元才可提现！", okString: "知道了")
//            }else{
//        
//         self.performSegue(withIdentifier: "Tixian", sender: self)
//    }
//        }
    }
    //菊花转动开始
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
    
    
        lazy var shareVc:JSShareView = {
            let shareView = JSShareView.init(title: "选择分享方式", imageArray: ["share_wechat","share_wxtimeline"], textArray: ["微信","朋友圈"])
            return shareView
        }()

    @objc func change() {
        //      print("3")
        var offset:CGPoint = scrollView.contentOffset
        offset.x = 20 + offset.x;
        scrollView .setContentOffset(offset, animated: true)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x < 0 {
            scrollView.scrollRectToVisible(CGRect(x: Int(scrollView.contentSize.width) - 2*Int(SWidth), y: 0, width: Int(SWidth), height: 30), animated: false)
        }else if scrollView.contentOffset.x >  SWidth * 2 {
            //就变到第二张的位置
            scrollView.scrollRectToVisible(CGRect(x: 0, y: 0, width: SWidth, height: 30), animated: false)
        }
//        print(scrollView.contentOffset.x)
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

                UserInfo.shared.setcurrentTime(currentTime: locadate!)
                print(UserInfo.shared.m_currentTime)

                
            }

        }
        task.resume()
        
        //        return nil;
        
    }
    
}
