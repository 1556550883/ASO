//
//  UserDetail.swift
//  mySolution
//
//  Created by 文高坡 on 2018/2/7.
//  Copyright © 2018年 bitse. All rights reserved.
//
import UIKit
import Alamofire

class UserDetail: UIViewController,UITableViewDataSource,UITableViewDelegate{
    @IBOutlet weak var scoreDay: UITextField!
    @IBOutlet weak var scoreSum: UITextField!
    @IBOutlet weak var score: UITextField!
    @IBOutlet weak var tixian: UIButton!
    @IBOutlet weak var loginName: UITextField!
    @IBOutlet weak var first_tableView: UITableView!
        @IBOutlet weak var tixianClick: UIButton!
    var m_vBtns:[UserBtnData] = [
        UserBtnData(icon:"detail_100", name:"收入明细", target:"ToScoreDetail"),
        UserBtnData(icon:"withdraw_100", name:"提现记录", target:"ToWithdraw"),
        UserBtnData(icon:"user_100", name:"个人信息", target:"ToUser"),
        UserBtnData(icon:"invite_100", name:"好友邀请", target:"ToInvite"),
        UserBtnData(icon:"help_100", name:"帮助中心", target:"ToHelp")];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(false, animated:false)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        tixian.clipsToBounds = false
        tixian.layer.cornerRadius = 5.0
        tixian.layer.rasterizationScale = UIScreen.main.scale
        tixian.layer.contentsScale =  UIScreen.main.scale
        
        
        first_tableView.dataSource = self;
        first_tableView.delegate = self;
    }
    
    @IBAction func onTiXianClick(_ sender: Any) {
        CommonFunc.alert(view: self, title: "提示", content: "请先绑定您的微信！", okString: "知道了")
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        scoreDay.text = String(format: "%.1f", UserInfo.shared.m_strScoreDay);
        score.text = String(format: "%.1f", UserInfo.shared.m_strScore) ;
        scoreSum.text = String(format: "%.1f", UserInfo.shared.m_strScoreSum);
        loginName.text = UserInfo.shared.m_strLoginName
        self.scoreDay.isUserInteractionEnabled = false
        self.score.isUserInteractionEnabled = false
        self.scoreSum.isUserInteractionEnabled = false
        self.loginName.isUserInteractionEnabled = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return m_vBtns.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        //1创建cell
        let identifier : String = "userinfocell"
        let cell:UserInfoCell = tableView.dequeueReusableCell(withIdentifier: identifier) as! UserInfoCell
      
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
        self.performSegue(withIdentifier: target!, sender: self)
        first_tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
