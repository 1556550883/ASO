//
//  UserInfo.swift
//  mySolution
//
//  Created by 战神 on 2017/6/4.
//  Copyright © 2017年 bitse. All rights reserved.
//

import Foundation
class UserInfo {
    
    static let shared = UserInfo();
    private init(){}
    
    //user id
    var m_strUserAppId:String = "";
    var m_strLoginName:String = "";
    var m_strPassWord:String = "";
    var m_strUserNum:String = "";
    var m_strScore:Float = 0.0;
    var m_vAdverInfo:[AnyObject]!;
    //user apple id
    var m_strAppId:String = "";
    var m_bCheckAppId:Bool = false;
    
    func setCheckAppId(b:Bool) -> Void {
        m_bCheckAppId = b;
    }
    func isCheckAppId() -> Bool {
        return m_bCheckAppId == true;
    }
    
    func setAppId(strAppId:String) {
        m_strAppId = strAppId;
    }
    
    func setAdverInfo(vAdverInfo:[AnyObject]) {
        m_vAdverInfo = vAdverInfo;
    }
    
    func setScore(score:Float) {
        m_strScore = score;
    }
    
    func setUserAppId(id:String) {
        m_strUserAppId = id;
    }
    
    func setLoginName(name:String) {
        m_strLoginName = name;
    }
    
    func setPassWord(password:String) {
        m_strPassWord = password;
    }
    
    func setUserNum(userNum:String){
        m_strUserNum = userNum
    }
    
    //将自身插入数据库接口
    func insertSelfToDB() {
        //插入SQL语句
        let insertSQL = "INSERT INTO 't_User' (username,password,appleid) VALUES ('\(m_strLoginName)','\(m_strPassWord)','\(m_strAppId)');"
        if SQLiteManager.shareInstance().execSQL(SQL: insertSQL) {
            print("插入数据成功")
        }else{
            print("插入数据fail")
        }
    }
    
    func deleteSelfToDB() {
        //插入SQL语句
        let insertSQL = "DELETE From 't_User'"
        if SQLiteManager.shareInstance().execSQL(SQL: insertSQL) {
            print("delete success")
        }else{
            print("delete fail")
        }
    }
    
    //MARK: - 类方法
    //将本对象在数据库内所有数据全部输出
    class func allUserFromDB() -> [[String : AnyObject]]? {
        let querySQL = "SELECT username,password,appleid FROM 't_User'"
        //取出数据库中用户表所有数据
        let allUserDictArr = SQLiteManager.shareInstance().queryDBData(querySQL: querySQL)
     
        return allUserDictArr
    }
}
