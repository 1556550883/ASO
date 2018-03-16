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
        
        self.tf_userid.text = UserInfo.shared.m_strLoginName
        self.tf_userid.isUserInteractionEnabled = false
        self.requestInfo();
    }
    
    @IBAction func inviteClick(_ sender: Any) {
     self.performSegue(withIdentifier: "ToInvite", sender: self)
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
        CommonFunc.alert(view: self, title: "提示", content: "请先绑定您的微信！", okString: "知道了")
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
