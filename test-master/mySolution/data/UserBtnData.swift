//
//  UserBtnData.swift
//  mySolution
//
//  Created by dudu on 2017/9/3.
//  Copyright © 2017年 bitse. All rights reserved.
//

import Foundation

class UserBtnData {
    
    var strIconName:String = "";
    var strName:String = "";
    var strTargetName:String = "";
    public init(icon:String, name:String, target:String)
    {
        strIconName = icon;
        strName = name;
        strTargetName = target;
    }

}
