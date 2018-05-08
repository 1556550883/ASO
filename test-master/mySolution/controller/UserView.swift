//
//  UserView.swift
//  mySolution
//
//  Created by 战神 on 2017/6/4.
//  Copyright © 2017年 bitse. All rights reserved.
//

import UIKit
import Alamofire

class UserView: UIViewController,UITableViewDelegate
{
    @IBOutlet var user_view: UIView!
    @IBOutlet var user_task: UIButton!
    @IBOutlet var tf_userid: UITextField!
    @IBOutlet var scoreDay: UITextField!
    @IBOutlet var score: UITextField!
    @IBOutlet var scoreSum: UITextField!
    @IBOutlet weak var inviteClick: UIButton!
    @IBOutlet weak var headImg: UIImageView!
    
    
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
        //self.performSegue(withIdentifier: "ToInvite", sender: self)
        self.sendWXContentFriend()
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
        message.title = "happy赚：" + ("点击下载" as! String)
        
        message.description="happy赚"
        message.setThumbImage(UIImage(named: "icon.png"));
        var ext:WXWebpageObject = WXWebpageObject();
        ext.webpageUrl = "https://www.pgyer.com/I49y";
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
        message.title = "happy赚：" + ("点击下载" as! String)
        message.description="happy赚"
        //这两步是把图片缩小的
        //var nowUIImage:UIImage = self.getNowUIImage();
        //var endUIImage:UIImage = viewClass.OriginImage(nowUIImage, ewidth: 100, eheight: 100)
        //message.setThumbImage(endUIImage);
        var ext:WXWebpageObject = WXWebpageObject();
        ext.webpageUrl = "https://www.pgyer.com/I49y";
        message.mediaObject = ext
        var resp = GetMessageFromWXResp()
        resp.message = message
        WXApi.send(resp);
    }
    
    @IBAction func playTaskClick(_ sender: Any){
        self.performSegue(withIdentifier: "task", sender: self)
    }
    
    func refreshView()
    {
        scoreDay.text = String(format: "%.1f", UserInfo.shared.m_strScoreDay);
        score.text = String(format: "%.1f", UserInfo.shared.m_strScore) ;
        scoreSum.text = String(format: "%.1f", UserInfo.shared.m_strScoreSum);
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
                        UserInfo.shared.setScore(score: score!);
                        UserInfo.shared.setScoreSum(scoreSum: scoreSum!);
                        UserInfo.shared.setScoreDay(scoreDay: scoreDay!)
                        
                        self.refreshView()
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
        
         self.performSegue(withIdentifier: "Tixian", sender: self)
//        if(UserInfo.shared.m_phonenum != "" && UserInfo.shared.m_weChat != ""){
//            if(UserInfo.shared.m_strScore <= 20){
//                CommonFunc.alert(view: self, title: "提示", content: "余额必须高于20元才可提现！", okString: "知道了")
//            }else{
//                let url =  Constants.m_baseUrl + "app/user/tixianRequest?userNum=" + UserInfo.shared.m_strUserNum
//                Alamofire.request(url).responseJSON {response in
//                    NetCtr.parseResponse(view: self, response: response, successHandler:{
//                        result,obj,msg in
//                        CommonFunc.alert(view: self, title: "提示", content: "提现申请成功，请等待管理员审核！", okString: "OK")
//                    })
//                }
//            }
//        }else{
//            CommonFunc.alert(view: self, title: "提示", content: "请先绑定您的微信和手机号码！", okString: "知道了")
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
    
}
