//
//  Common.swift
//  mySolution
//
//  Created by dudu on 17/6/3.
//  Copyright © 2017年 bitse. All rights reserved.
//
import AdSupport
import Foundation
import UIKit
import Alamofire
import CoreFoundation

class CommonFunc {
    private init(){};
    
    public static func goto(from:UIViewController, target:String)->Void{
        DispatchQueue.main.async(execute: {from.performSegue(withIdentifier: target, sender: from)})
    }
    
    //获取idfa
    public static func getIDFA() -> String {
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString;
    }
    //获取ip地址
    public static func getIFAddresses() -> [String] {
        var addresses = [String]()
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return [] }
        guard let firstAddr = ifaddr else { return [] }
        
        // For each interface ...
        for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let flags = Int32(ptr.pointee.ifa_flags)
            var addr = ptr.pointee.ifa_addr.pointee
            
            // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
            if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                if addr.sa_family == UInt8(AF_INET) {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                                    nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                        let address = String(cString: hostname)
                        addresses.append(address)
                    }
                }
            }
        }
        freeifaddrs(ifaddr)
        CommonFunc.log(addresses);
        return addresses
    }
    
    public static func getPubIp()->String
    {
        var ret:String!;
        let ips = CommonFunc.getIFAddresses();
        for ip in ips {
            let offsetIndex: String.Index = ip.index(ip.startIndex, offsetBy:4)
            let tmp = ip.substring(to: offsetIndex)
            CommonFunc.log(tmp.compare("192.").hashValue)
            if tmp.compare("192.").hashValue == 0
            {
                ret = ip;
                break;
            }

        }
        if ret == nil
        {
            ret = ips[0];
        }
        if ret == nil
        {
            ret = "";
        }
        return ret;
    }
    
    //通过bundleid打开应用
    public static func openApp(bundleid:String)->Bool
    {
//        [[LMAppController sharedInstance] openAppWithBundleIdentifier:self.app.bundleIdentifier]
        return LMAppController.sharedInstance().openApp(withBundleIdentifier: bundleid)
    }
    
    //跳转到appstore
    public static func gotoAppStore(urlString:String) {
        //let urlString = "itms-apps://itunes.apple.com/app/id444934666"
        let url = URL(string:urlString)!;
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler:{
                (sucess) in
                
            })
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(url);
        }
    }
    
    //获取当前时间
    public static func getTime() -> String {
        let date = NSDate()
        
        let timeFormatter = DateFormatter()
        
        timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        
        let strNowTime = timeFormatter.string(from: date as Date) as String
        return strNowTime
    }

    //弹框
    public static func alert(view:UIViewController, title:String, content:String, okString:String, okHandler:((UIAlertAction) -> Swift.Void)? = nil, exitString:String = "", exithandler:((UIAlertAction) -> Swift.Void)? = nil) {
        let alertController = UIAlertController(title: title, message: content, preferredStyle: .alert)
        
        if (exitString != "")
        {
            let cancelAction = UIAlertAction(title: exitString, style: .cancel, handler: exithandler)
            alertController.addAction(cancelAction)
        }
        
        let okAction = UIAlertAction(title: okString, style: .default, handler:okHandler)
        alertController.addAction(okAction)
        view.present(alertController, animated: true, completion: nil)
    }
    
    //传入字符串、字体      返回NSMutableAttributedString
    public static func appendStrWithString(str:String,font:CGFloat) -> NSMutableAttributedString {
        var attributedString : NSMutableAttributedString
        let attStr = NSMutableAttributedString.init(string: str, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: font)])
        attributedString = NSMutableAttributedString.init(attributedString: attStr)
        return attributedString
    }
    
    //传入字符串、字体、颜色      返回NSMutableAttributedString
    public static func appendColorStrWithString(str:String,font:CGFloat,color:UIColor) -> NSMutableAttributedString {
        var attributedString : NSMutableAttributedString
        let attStr = NSMutableAttributedString.init(string: str, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: font),NSForegroundColorAttributeName:color])
        attributedString = NSMutableAttributedString.init(attributedString: attStr)
        return attributedString
    }
    
    //秒数转为 时:分:秒
    public static func getHHMMSSFormSS(seconds:Int) -> String {
        let str_date = NSString(format: "%02ld", seconds/(3600 * 24))
        let str_hour = NSString(format: "%02ld", seconds%(3600 * 24)/3600)
        let str_minute = NSString(format: "%02ld", (seconds%(3600 * 24)%3600)/60)
        let str_second = NSString(format: "%02ld", seconds%60)
        let format_time = NSString(format: "%@天 %@:%@:%@",str_date,str_hour,str_minute,str_second)
        return format_time as String
    }
    
    public static func getNowTime() -> Date {
        let date = NSDate()
        
        let timeFormatter = DateFormatter()
        
        timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let strNowTime = timeFormatter.string(from: date as Date) as String
        
        return timeFormatter.date(from: strNowTime)!;
    }
    
    //获取时间差
    public static func getTimeInterval(create_time:Date, end_time:Date, limitTime:Int) -> String {
        
        let timeNumber = Int(end_time.timeIntervalSince1970 - create_time.timeIntervalSince1970)
        let interval = limitTime * 60 - timeNumber;
        
        if(interval <= 0)
        {
            return "0";
        }
        
        return self.getHHMMSSFormSS(seconds: interval)
    }
    
    //money
    public static func money(money:String, pluesize:CGFloat = 17.0, numsize:CGFloat = 42, yuansize:CGFloat = 17.0) -> NSMutableAttributedString {
        //定义富文本即有格式的字符串
        let attributedStrM : NSMutableAttributedString = NSMutableAttributedString()
        
        
        let strPlus : NSAttributedString = NSAttributedString(string: "+", attributes: [ NSFontAttributeName : UIFont.boldSystemFont(ofSize: pluesize)])
        
        let strMoney : NSAttributedString = NSAttributedString(string: money, attributes: [NSForegroundColorAttributeName : UIColor.red, NSFontAttributeName : UIFont.systemFont(ofSize: 42.0)])
        
        let strYuan : NSAttributedString = NSAttributedString(string: "元", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: yuansize)])
        
        attributedStrM.append(strPlus)
        attributedStrM.append(strMoney)
        attributedStrM.append(strYuan)
        
        return attributedStrM

    }
    
    //html文本
    public static func convertHtml2String(label:UILabel, htmlText:String) {
        do {
            let attrStr = try NSAttributedString(data: htmlText.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
            
            label.attributedText = attrStr;
        }catch let error as NSError
        {
            print(error.localizedDescription)
        }
    }
    
    //打印
    public static func log(_ values:Any...){
        #if DEBUG
            print(values);
        #endif
    }
    
    //下载图片
    public static func download(url:String, save:String, callBack:@escaping (String)->())
    {
        
        //指定下载路径和保存文件名
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(save)
            //两个参数表示如果有同名文件则会覆盖，如果路径中文件夹不存在则会自动创建
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        //开始下载
        Alamofire.download(url, to: destination)
            .response { response in
                print(response)
                
                if let imagePath = response.destinationURL?.path {
                    callBack(imagePath);
                }
            }

    }
    
    //获取设备
    public static func getDevice() -> String
    {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
    public static func getDeviceEx()->String
    {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone4"
        case "iPhone4,1":                               return "iPhone4"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone5"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone5"
        case "iPhone7,2":                               return "iPhone6"
        case "iPhone7,1":                               return "iPhone6"
        case "iPhone8,1":                               return "iPhone6"
        case "iPhone8,2":                               return "iPhone6"
        default:                                        return identifier
        }
    }
    
    /// JSONString转换为字典
    ///
    /// - Parameter jsonString: <#jsonString description#>
    /// - Returns: <#return value description#>
    static func getDictionaryFromJSONString(jsonString:String) ->NSDictionary{
        
        let jsonData:Data = jsonString.data(using: .utf8)!
        
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
        
        
    }
    
    /**
     字典转换为JSONString
     
     - parameter dictionary: 字典参数
     
     - returns: JSONString
     */
    static func getJSONStringFromDictionary(dictionary:NSDictionary) -> String {
        if (!JSONSerialization.isValidJSONObject(dictionary)) {
            print("无法解析出JSONString")
            return ""
        }
        let data : NSData! = try? JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData!
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
        
    }
    
    static func saveLocalData(dic:[String:String], file:String = "GameData.plist") {
        
        
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        
        let documentsDirectory = paths.object(at: 0) as! NSString
        
        
        let path = documentsDirectory.appendingPathComponent(file)
        
        
//        print(path)
        let dict: NSMutableDictionary = ["itializerItem": "DoNotEverChangeMe"]
        
        //saving values
        for (key, value) in dic
        {
            dict.setObject(value, forKey: key as NSCopying);
        }
       
        
        //...
        
        
        
        //writing to GameData.plist
        
        dict.write(toFile: path, atomically: false)
        
        
        
        let resultDictionary = NSMutableDictionary(contentsOfFile: path)
        
        print("Saved LocalData.plist file is --> \(String(describing: resultDictionary?.description))")
        
        
        
    }
    
    static func loadLocalData(file:String = "GameData.plist")->[String:String] {
        
        
        var result:[String:String] = [:];
        // getting path to GameData.plist
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        
        let documentsDirectory = paths[0] as! NSString
        
        let path = documentsDirectory.appendingPathComponent(file)
        
        let fileManager = FileManager.default
        
        //check if file exists
        
        if(!fileManager.fileExists(atPath: path)) {
            
            // If it doesn't, copy it from the default file in the Bundle
            
            if let bundlePath = Bundle.main.path(forResource: "GameData", ofType: "plist") {
                
                
                
                let resultDictionary = NSMutableDictionary(contentsOfFile: bundlePath)
                
                print("Bundle GameData.plist file is --> \(String(describing: resultDictionary?.description))")
//
                try! fileManager.copyItem(atPath: bundlePath, toPath: path)
                
                print("copy")
                
            } else {
                
                print("GameData.plist not found. Please, make sure it is part of the bundle.")
                
            }
            
        } else {
            
            print("GameData.plist already exits at path.")
            
//             use this to delete file from documents directory
            
//            fileManager.removeItemAtPath(path, error: nil)
            
        }
        
        
        
        let resultDictionary = NSMutableDictionary(contentsOfFile: path)
        
        print("Loaded GameData.plist file is --> \(String(describing: resultDictionary?.description))")
        
        
        
        let myDict = NSDictionary(contentsOfFile: path)
        
        
        
        if let dict = myDict {
            
            //loading values
            
            result = dict as! [String : String];
            
            print(result)
            
            
            //...
            
        } else {
            
            print("WARNING: Couldn't create dictionary from GameData.plist! Default values will be used!")
            
        }
        return result
    }
    
    static public func validateEmail(email: String) -> Bool {
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        return emailTest.evaluate(with: email)
        
    }
}
