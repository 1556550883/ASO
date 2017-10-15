//
//  MyTableBarController.swift
//  mySolution
//
//  Created by dudu on 17/6/1.
//  Copyright © 2017年 bitse. All rights reserved.
//

import UIKit

class HomeView: UITabBarController,UITabBarControllerDelegate {
    var result:AnyObject!;
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
//        let leftBarBtn = UIBarButtonItem(title: "退出登录", style: .plain, target: self, action: #selector(backToSelectLogin))
//        self.navigationItem.leftBarButtonItem = leftBarBtn;
        // Do any additional setup after loading the view.
    }

    func backToSelectLogin() -> Void {
        self.navigationController?.popToRootViewController(animated: true);
//        self.navigationController?.pushViewController(SelectLoginTypeView(), animated: true);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
