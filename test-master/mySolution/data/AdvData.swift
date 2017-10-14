//
//  AdvData.swift
//  mySolution
//
//  Created by 战神 on 2017/6/4.
//  Copyright © 2017年 bitse. All rights reserved.
//

import Foundation
class AdvData{
    
    var m_strName:String = "";
    var m_strAdId:String = "";
    var m_strUrl:String = "";
    var m_strAdverId:String = "";
    var m_strAdvDes:String = "";
    var m_strPrice:String = "";
    //任务开始时间
    var m_dateAdverDayEnd:Date? = nil;
    //任务结束时间
    var m_dateAdverDayStart:Date? = nil;
    var m_strRemainNum:String! = "";
    var m_strImgUrl:String = "";
    var m_strBundleId:String = "";
    var m_strTaskType:String = "";
    var m_timeLimit:Int = 30;
    
    //单个app体验时间
    var m_iTimeRelease:UInt = 0;
    
    //设置体验时间
    public func setExpTime(time:UInt)
    {
        m_iTimeRelease = time;
    }
    
    public func setTaskType(tasktype:String)
    {
        m_strTaskType = tasktype;
    }
    
    public func setBundleId(bundleid:String)
    {
        m_strBundleId = bundleid;
    }
    
    public func setImg(img:String)
    {
        m_strImgUrl = img;
    }
    
    public func setRemainNum(remain:String?)
    {
        m_strRemainNum = remain;
    }
    
    public func setDayEnd(str:Date)
    {
        m_dateAdverDayEnd = str;
    }
    
    public func setDayStart(str:Date)
    {
        m_dateAdverDayStart = str
    }
    
    public func setPrice(price:String)
    {
        m_strPrice = price;
    }
    
    public func setDes(des:String)
    {
        m_strAdvDes = des;
    }
    
    public func setName(name:String)
    {
        m_strName = name;
    }
    
    public func setAdId(id:String)
    {
        m_strAdId = id;
    }
    
    public func setAdverId(id:String)
    {
        m_strAdverId = id;
    }
    
    public func setTimeLimit(timeLimit:String)
    {
        m_timeLimit = Int(timeLimit)!;
    }
    
    public func setUrl(url:String)
    {
        let whitespace = NSCharacterSet.whitespacesAndNewlines
        let urlString = url.trimmingCharacters(in: whitespace)
        m_strUrl = urlString.replacingOccurrences(of: "https:", with: "itms-apps:")   ;
    }
}
