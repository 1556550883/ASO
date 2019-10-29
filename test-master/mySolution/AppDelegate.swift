//
//  AppDelegate.swift
//  mySolution
//
//  Created by clare on 2017/5/25.
//  Copyright © 2017年 bitse. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , WXApiDelegate{

    var window: UIWindow?
    //后台任务
    var backgroundTask:UIBackgroundTaskIdentifier! = nil

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if SQLiteManager.shareInstance().openDB() {
            print("开启数据库成功!")
        }
        
        WXApi.registerApp("wx976c46a725b070f6")
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        WXApi.handleOpen(url, delegate: self)
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        WXApi.handleOpen(url, delegate: self)
        return true
    }
    
    /**  微信会调  */
    func onResp(_ resp: BaseResp!) {
        if resp.errCode == 0 && resp.type == 0{//授权成功
            
            if(resp is SendAuthResp){
                let response = resp as! SendAuthResp
                //发送到朋友圈返回的类型
                //let responsel = resp as! SendMessageToWXResp
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "WXLoginSuccessNotification"), object: response.code)
            }
            
            //发送到朋友圈返回的类型
             //let responsel = resp as! SendMessageToWXResp
        }
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        
        //如果已存在后台任务，先将其设为完成
        if self.backgroundTask != nil {
            application.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = UIBackgroundTaskInvalid
        }
        
        //如果后台还需要申请
        if (BackGroundTimer.shared.isBackTrig())
        {
            //注册后台任务
            self.backgroundTask = application.beginBackgroundTask(expirationHandler: {
                () -> Void in
                //如果没有调用endBackgroundTask，时间耗尽时应用程序将被终止
                application.endBackgroundTask(self.backgroundTask)
                self.backgroundTask = UIBackgroundTaskInvalid
            })
        }
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

