//
//  WechatInfo.swift
//  mySolution
//
//  Created by 文高坡 on 2018/4/2.
//  Copyright © 2018年 bitse. All rights reserved.
//

import Foundation
class WechatInfo{
    static let wechatInfo = WechatInfo();
    private init(){}

    var m_nickName:String = "";
    var m_headimgurl:String = "";
    
    func setNickName(nickName:String) {
        m_nickName = nickName;
    }
    
    func setHeadimgurl(headimgurl:String) {
        m_headimgurl = headimgurl;
    }
}
