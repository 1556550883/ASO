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
    var m_struserNick:String = "";
    
    var m_tongzhi:String = "";
    var m_shareUrl:String = "";
     var m_idfaCheck:String = "";
    
    var m_currentTime:Date = Date();
    
    
    var m_isTixianL:Float = 0.0;
    
    
    var m_strScore:Float = 0.0;
    var m_strLeastMoney:Float = 0.0;
    
    var m_NumType:Float = 0.0;
    
    
    var m_strScoreDay:Float = 0.0;
    var m_strScoreSum:Float = 0.0;
    var m_vAdverInfo:[AnyObject]! = [];
    var m_RecordInfo:[AnyObject]! = [];
    //user apple id
    var m_strAppId:String = "";
    var m_bCheckAppId:Bool = false;
    var m_idfa:String = "";
    var m_sys_version = "";
    var m_phonenum = ""
    var m_weChat = ""
    var m_weChatHeadImg = ""
    var m_zhifubao = ""
    
    func setuserNick(userNick:String){
        m_struserNick = userNick
    }
    func setcurrentTime(currentTime:Date){
        m_currentTime = currentTime
    }
    func setShareUrl(ShareUrl:String){
        m_shareUrl = ShareUrl
    }
    func setTongzhi(tongzhi:String){
        m_tongzhi = tongzhi
    }
    
    func setIdfaCheck(idfaCheck:String){
        m_idfaCheck = idfaCheck
    }
    
    func setZhifubao(zhifubao:String){
        m_zhifubao = zhifubao
    }
    
    func setWechatHeadImg(wechatHeadImg:String){
        m_weChatHeadImg = wechatHeadImg
    }
    
    func setPhonenum(phoneNum:String){
        m_phonenum = phoneNum
    }
    
    func setWeChat(weChat:String){
        m_weChat = weChat
    }
    
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
    func setRecordInfo(vRecordInfo:[AnyObject]) {
        m_RecordInfo = vRecordInfo;
    }
    func setScore(score:Float) {
        m_strScore = score;
    }
    func setType(type:Float) {
        m_NumType = type;
    }
    func setLeastMoney(LeastMoney:Float) {
        m_strLeastMoney = LeastMoney;
    }
    func setisTixian(isTixian:Float) {
        m_isTixianL = isTixian;
    }
    func setScoreDay(scoreDay:Float) {
        m_strScoreDay = scoreDay;
    }
    
    func setScoreSum(scoreSum:Float) {
        m_strScoreSum = scoreSum;
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
    
    func setMidfa(idfa:String) {
        m_idfa = idfa;
    }
    
    func setSysVersion(version:String) {
        m_sys_version = version;
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
