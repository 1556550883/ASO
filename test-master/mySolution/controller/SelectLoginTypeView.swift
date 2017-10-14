//
//  SelectLoginTypeView.swift
//  mySolution
//
//  Created by dudu on 2017/9/4.
//  Copyright © 2017年 bitse. All rights reserved.
//

import UIKit
import Alamofire

class SelectLoginTypeView: UIViewController {

    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)

    @IBAction func onPwdClick(_ sender: Any) {
        CommonFunc.goto(from: self, target: "login_with_pwd");
    }
    
    @IBAction func onGuestClick(_ sender: Any)
    {
        play()
        let idfa = CommonFunc.getIDFA();
        let url = Constants.m_baseUrl + "app/user/visitorLogin?idfa=" + idfa;
        Alamofire.request(url).responseJSON
        {
            response in
            NetCtr.parseResponse(view: self, response: response, successHandler:
            {
                obj,msg in
                let userAppId = obj["userAppId"]?.stringValue;
                let loginName = obj["loginName"] as! String;
                let userNum = obj["userNum"] as! String;
                let score = obj["score"]?.floatValue;
                UserInfo.shared.setUserAppId(id:userAppId! )
                UserInfo.shared.setLoginName(name:loginName)
                UserInfo.shared.setUserNum(userNum: userNum)
                UserInfo.shared.setScore(score: score!)
                
                CommonFunc.goto(from: self, target: "login_with_guest");
            })
        
            self.stop()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initIndicator()
//        self.navigationController?.pushViewController(LoginView(), animated: true);
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
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
