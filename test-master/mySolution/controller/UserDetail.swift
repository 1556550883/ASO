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
    @IBOutlet weak var weHeadImg: UIImageView!
    @IBOutlet weak var tixianClick: UIButton!
    
    let userView = UserView()
    
    
    
    var m_vBtns:[UserBtnData] = [
        UserBtnData(icon:"detail_100", name:"收入明细", target:"ToScoreDetail"),
        UserBtnData(icon:"withdraw_100", name:"提现记录", target:"ToWithdraw"),
        UserBtnData(icon:"information", name:"个人信息", target:"ToUser"),
        UserBtnData(icon:"inviteimage", name:"好友邀请", target:"ToInvite"),
        UserBtnData(icon:"help_100", name:"帮助中心", target:"ToHelp")];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(false, animated:false)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let button = UIButton(frame: CGRect(x:0,y:0,width:15,height:20))
        button.setBackgroundImage(UIImage(named:"push"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(pushback), for: UIControlEvents.touchUpInside)
        let item = UIBarButtonItem(customView:button)
        
        self.navigationItem.leftBarButtonItem = item

        
        
        tixian.clipsToBounds = false
        tixian.layer.cornerRadius = 5.0
        tixian.layer.rasterizationScale = UIScreen.main.scale
        tixian.layer.contentsScale =  UIScreen.main.scale
        
        weHeadImg.clipsToBounds = false
        weHeadImg.layer.cornerRadius = 5.0
        weHeadImg.layer.rasterizationScale = UIScreen.main.scale
        weHeadImg.layer.contentsScale = UIScreen.main.scale
//        weHeadImg.backgroundColor =  UIColor.gray
        
        first_tableView.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1.0)
        first_tableView.dataSource = self;
        first_tableView.delegate = self;
        first_tableView.separatorColor = UIColor.clear
        if(UserInfo.shared.m_weChatHeadImg != ""){
            let url = URL(string: UserInfo.shared.m_weChatHeadImg)
            self.weHeadImg.kf.setImage(with: url)
        }
        
        self.userView.shareVc.itemClickBlock = { (index) in
            if index == 0 {
                self.userView.sendWXContentUser()
            }else if index == 1{
                self.userView.sendWXContentFriend()
                
            }
            
        }
        
    }
    
    @objc func pushback() {
        self.navigationController?.popViewController(animated:true)
    }
    
    @IBAction func onTiXianClick(_ sender: Any) {
       
        
        if(UserInfo.shared.m_phonenum != "" && UserInfo.shared.m_weChat != ""){
            if(UserInfo.shared.m_phonenum != "" && UserInfo.shared.m_weChat != ""){
                if(UserInfo.shared.m_strScore <= UserInfo.shared.m_strLeastMoney){
                    CommonFunc.alert(view: self, title: "提示", content: "余额必须高于"+String(UserInfo.shared.m_strLeastMoney)+"元才可提现！", okString: "知道了")
                }else{


                    self.performSegue(withIdentifier: "tixianmoney", sender: self)


                    
                }
            }
        }else{
            CommonFunc.alert(view: self, title: "提示", content: "请先绑定您的微信和手机号码！", okString: "知道了")
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        scoreDay.text = String(format: "%.1f元", UserInfo.shared.m_strScoreDay);
        score.text = String(format: "%.1f元", UserInfo.shared.m_strScore) ;
        scoreSum.text = String(format: "%.1f元", UserInfo.shared.m_strScoreSum);
        if(UserInfo.shared.m_weChat != ""){
            self.loginName.text = UserInfo.shared.m_weChat;
        }else{
            self.loginName.text = UserInfo.shared.m_strLoginName
        }
        self.scoreDay.isUserInteractionEnabled = false
        self.score.isUserInteractionEnabled = false
        self.scoreSum.isUserInteractionEnabled = false
        self.loginName.isUserInteractionEnabled = false
        if(UserInfo.shared.m_weChatHeadImg != ""){
            let url = URL(string: UserInfo.shared.m_weChatHeadImg)
            self.weHeadImg.kf.setImage(with: url)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {    if(section == 1){
        return 3;
    }else{
        return 2;
        }
//        return m_vBtns.count;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2;
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 10;
        }
        
        
        return 30;
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let view = UIView()
        view.backgroundColor = UIColor(red:239/255,green:239/255,blue:244/255,alpha:1.0)
        return view;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        //1创建cell
        let identifier : String = "userinfocell"
        let cell:UserInfoCell = tableView.dequeueReusableCell(withIdentifier: identifier) as! UserInfoCell
      
        if (indexPath.row < m_vBtns.count)
        {
            let data = m_vBtns[indexPath.row + indexPath.section * 2];
            let icon = data.strIconName;
            let name = data.strName;
            
            cell.m_data = data;
            
            let path = Bundle.main.path(forResource: icon, ofType: "png")
            let newImage = UIImage(contentsOfFile: path!)
            cell.m_img.image = newImage;
            cell.m_label?.text = name;
        }
   
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator//添加箭头
        
                cell.selectionStyle = UITableViewCellSelectionStyle.none
        let label = UILabel(frame:CGRect(x:20,y:48,width:self.view.frame.size.width - 50,height:2));
        label.backgroundColor = UIColor(red:239/255,green:239/255,blue:244/255,alpha:1.0)
        cell.contentView.addSubview(label);
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        
        
        if (indexPath.row == 1 && indexPath.section == 1) {
//            self.userView.shareVc.show()
            CommonFunc.alert(view: self, title: "没有分享了！！", content: "", okString: "知道了");

        }else{
            let cell = tableView.cellForRow(at: indexPath) as! UserInfoCell;
            let data = cell.m_data;
            let target = data?.strTargetName;
            self.performSegue(withIdentifier: target!, sender: self)
        }
        first_tableView.deselectRow(at: indexPath, animated: true)

        
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50;
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
