//
//  TixianView.swift
//  mySolution
//
//  Created by 文高坡 on 2018/4/24.
//  Copyright © 2018年 bitse. All rights reserved.
//

import UIKit
import Alamofire

class TixianView: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    //菊花
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(false, animated:false)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let button = UIButton(frame: CGRect(x:0,y:0,width:15,height:20))
        button.setBackgroundImage(UIImage(named:"push"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(pushback), for: UIControlEvents.touchUpInside)
        let item = UIBarButtonItem(customView:button)
        
        self.navigationItem.leftBarButtonItem = item
        

        tableView.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1.0)
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorColor = UIColor.clear
        
        queryTaskSum()

    }
    func queryTaskSum(){
        self.play()
        let url =  Constants.m_baseUrl + "app/userScore/getForwardScore?userNum=" + UserInfo.shared.m_strUserNum
        Alamofire.request(url).responseJSON {response in
            NetCtr.parseResponse(view: self, response: response, successHandler:{
                result, obj, msg in
                let array = obj["result"] as! Array<AnyObject>
                print(array)
                if(array.count == 0){
                    CommonFunc.alert(view: self, title: "提示！！", content: "现在还么有提现记录！！！", okString: "OK");
                    
                    
                    
                }

                
                UserInfo.shared.setRecordInfo(vRecordInfo:array)
//                UserInfo.shared.setAdverInfo(vAdverInfo: array)
                self.tableView.reloadData();
                self.stop()
            })
        }
    }
    @objc func pushback() {
        self.navigationController?.popViewController(animated:true)
    }
    
//    tabelview的代理
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //1创建cell
        let identifier : String = "cashUpCell"
        let cell:cashUpCell = tableView.dequeueReusableCell(withIdentifier: identifier) as! cashUpCell
        
        
        let recored = UserInfo.shared.m_RecordInfo[indexPath.row];

        cell.TimeLabel.text = recored["scoreTime"] as! String
        let state = recored["status"] as? NSNumber
//        let money = recored["score"] ;
        let mmm:Int = recored["score"]!! as! Int
        
        print(mmm)
//        let kkk = mmm!!
//        let scoreSum = obj["scoreSum"]?.floatValue;
//        let price = adverinfo["adverPrice"] as? NSNumber

//        let nnn:String = (kkk as! String)
        
//        cell.MoneyLabel.text =
        print(cell.MoneyLabel.text as Any,"00000")
//        cell.MoneyLabel.backgroundColor = UIColor.red
        if (state == 0) {
            cell.MoneyLabel.text =  String(mmm)+"元"+"审核中"
        }else{
            cell.MoneyLabel.text = String(mmm)+"元"+"提现成功"

        }
        
        
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        let label = UILabel(frame:CGRect(x:25,y:48,width:self.view.frame.size.width - 50,height:1));
        label.backgroundColor = UIColor(red:239/255,green:239/255,blue:244/255,alpha:1.0)
//        label.backgroundColor = UIColor.black;
        cell.contentView.addSubview(label);
        return cell
    }
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//                return 9
        return UserInfo.shared.m_RecordInfo.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
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
