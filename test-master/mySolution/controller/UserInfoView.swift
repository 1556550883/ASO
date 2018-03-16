//
//  UserInfoView.swift
//  mySolution
//
//  Created by 文高坡 on 2018/2/11.
//  Copyright © 2018年 bitse. All rights reserved.
//

import UIKit
import Alamofire

class UserInfoView: UIViewController {
   @IBOutlet weak var userID: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userID.text = UserInfo.shared.m_strUserAppId
    }
}

