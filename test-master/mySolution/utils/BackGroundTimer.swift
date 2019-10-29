//
//  Global.swift
//  mySolution
//
//  Created by dudu on 2017/8/12.
//  Copyright © 2017年 bitse. All rights reserved.
//

import Foundation
class BackGroundTimer {
    private init(){}
    public static let shared = BackGroundTimer();
    
    var m_back_trig:Bool = false;
    var m_back_schedule_entry:Timer? = nil
    //体验时间
    var m_experiencing_time:UInt = 20;
    //体验时间剩余
    var m_tick_time_release:UInt = 0;
    let m_tick_delta_second:UInt = 1;
    var m_tick_open_bundleid:String = "";
    
    public func setExpTime(time:UInt)
    {
        m_experiencing_time = time;
    }
    
    public func setBackToggle(open:Bool)
    {
        m_back_trig = open;
    }
    
    public func isBackTrig()->Bool
    {
        return m_back_trig == true;
    }
    
    public func startBackTick(sec:UInt = 0, bundleid:String = "")
    {
        stopBackTick();
        setBackToggle(open: true);
//        m_tick_time_release = sec;
        m_tick_time_release = m_experiencing_time;
        m_tick_open_bundleid = bundleid;
        
        CommonFunc.log("后台保障运行:" + String(m_tick_time_release), String(m_tick_open_bundleid) ?? "");
        
        m_back_schedule_entry = Timer.scheduledTimer(timeInterval: TimeInterval(m_tick_delta_second),target:self,selector:#selector(self.tick_openapp),userInfo:nil,repeats:true)

    }
    
    public func stopBackTick()
    {
        if (m_back_schedule_entry != nil)
        {
            m_back_schedule_entry?.invalidate();
            m_back_schedule_entry = nil;
        }
        setBackToggle(open: false);
    }
    
    @objc func tick_openapp() {
        m_tick_time_release = m_tick_time_release - m_tick_delta_second;
        if (m_tick_time_release <= 0 )
        {
            self.stopBackTick();
        }
        else
        {
            _ = CommonFunc.openApp(bundleid:m_tick_open_bundleid);
        }
    }
}
