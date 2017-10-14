//
//  UserView.swift
//  mySolution
//
//  Created by 战神 on 2017/6/4.
//  Copyright © 2017年 bitse. All rights reserved.
//

import UIKit
import Alamofire

class UserView: UIViewController,UITableViewDataSource,UITableViewDelegate
{
    @IBOutlet weak var tf_money: UILabel!
    
    @IBOutlet weak var scr_detail: UITableView!
    
    @IBOutlet weak var tf_userid: UILabel!
    
    
    @IBOutlet weak var m_tableview: UITableView!
    
    var m_vBtns:[UserBtnData] = [
        UserBtnData(icon:"man", name:"个人信息", target:"null"),
        UserBtnData(icon:"drink-toast", name:"邀请好友", target:"null"),
        UserBtnData(icon:"gift", name:"收入明细", target:"scoredetail"),
        UserBtnData(icon:"search", name:"提现记录", target:"null")];
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        m_tableview.dataSource = self;
        m_tableview.delegate = self;
    }

    override func viewDidAppear(_ animated: Bool)
    {
        self.tf_userid.text = UserInfo.shared.m_strUserAppId;
        
        self.requestInfo();
    }
    
    func refreshView()
    {
        tf_money.text = String(format: "%.1f", UserInfo.shared.m_strScore) ;
    }
    
    func requestInfo()
    {
        self.tf_money.text = "???"
        let userNum = UserInfo.shared.m_strUserNum
        let url = Constants.m_baseUrl + "app/userScore/getScore?userNum=" + userNum;
        Alamofire.request(url).responseJSON
            {
                response in
                NetCtr.parseResponse(view: self, response: response, successHandler:
                    {
                        obj,msg in
                        let score = obj["score"]!
                       
                        UserInfo.shared.setScore(score: score);
                        
                        self.refreshView()
                })
        }
    }
    
//    func requestInfo()
//    {
//        self.tf_money.text = "???"
//        let userNum = UserInfo.shared.m_strUserNum
//        let url = Constants.m_baseUrl + "app/userScore/getScore?userNum=" + userappid;
//        Alamofire.request(url).responseJSON
//        {
//            response in
//            NetCtr.parseResponse(view: self, response: response, successHandler:
//            {
//                obj,msg in
//                let userInfo = obj["userInfo"]!
//                let userScore = userInfo["userScore"] as! [String:AnyObject]
//
//                let adverInfo = obj["adverInfo"] as! [AnyObject]
//                UserInfo.shared.setAdverInfo(vAdverInfo: adverInfo)
//
//                UserInfo.shared.setScore(score: (userScore["score"]?.floatValue)!);
//
//                self.refreshView()
//            })
//        }
//    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onDetailClick(_ sender: Any)
    {
        self.performSegue(withIdentifier: "scoredetail", sender: self)
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return m_vBtns.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        //1创建cell
        let identifier : String = "userinforcell"
        var cell:UserInfoCell = tableView.dequeueReusableCell(withIdentifier: identifier) as! UserInfoCell
        if cell == nil
        {
            //在swift中使用枚举类型方式 1>枚举类型.具体类型  2> .具体类型
            cell = UserInfoCell(style: UITableViewCellStyle.value1, reuseIdentifier: identifier)
        }
        
        if (indexPath.row < m_vBtns.count)
        {
            let data = m_vBtns[indexPath.row];
            let icon = data.strIconName;
            let name = data.strName;
            
            cell.m_data = data;
            
            let path = Bundle.main.path(forResource: icon, ofType: "png")
            let newImage = UIImage(contentsOfFile: path!)
            cell.m_img.image = newImage;
            cell.m_label?.text = name;
        }
        
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator//添加箭头
        
//        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath) as! UserInfoCell;
        let data = cell.m_data;
        let target = data?.strTargetName;
        if (target != "null" )
        {
            self.performSegue(withIdentifier: target!, sender: self)
        }
        else
        {
            CommonFunc.alert(view: self, title: "提示", content: "该功能暂未开放，敬请期待！", okString: "知道了")
        }
        m_tableview.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
//        let destinationView = segue.destination as! AdvDetail
//        
//        destinationView.m_objData = m_objCurData
    }
    
    
    @IBAction func onTiXianClick(_ sender: Any)
    {
        CommonFunc.alert(view: self, title: "提示", content: "该功能暂未开放，敬请期待！", okString: "知道了")
    }
}
