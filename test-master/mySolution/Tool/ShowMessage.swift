//
//  ShowMessage.swift
//  mySolution
//
//  Created by 你若化成风 on 2018/5/21.
//  Copyright © 2018年 bitse. All rights reserved.
//

import UIKit

class ShowMessage: UIView {

    
    public static func messageShow( title:String) {
        let window = UIWindow()
        let showview = UIView()
        showview.frame = CGRect(x: 1, y: 1, width: 1, height: 1);
        showview.alpha = 1.0
        showview.layer.masksToBounds = true
        showview.layer.cornerRadius = 5.0
        window.addSubview(showview)
        
        let label = UILabel()
//        let labelSize:CGSize = title.bounding
        
//        let size = string.boundingRectWithSize(size2, options: NSStringDrawingOptions.UsesFontLeading, attributes: nil, context: nil);

        
        
        
        
    }
    
   
    
    public static func iphoneType() ->String {
        
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let platform = withUnsafePointer(to: &systemInfo.machine.0) { ptr in
            return String(cString: ptr)
        }
        
//        if platform == "iPhone1,1" { return "iPhone 2G"}
//        if platform == "iPhone1,2" { return "iPhone 3G"}
//        if platform == "iPhone2,1" { return "iPhone 3GS"}
//        if platform == "iPhone3,1" { return "iPhone 4"}
//        if platform == "iPhone3,2" { return "iPhone 4"}
//        if platform == "iPhone3,3" { return "iPhone 4"}
//        if platform == "iPhone4,1" { return "iPhone 4S"}
//        if platform == "iPhone5,1" { return "iPhone 5"}
//        if platform == "iPhone5,2" { return "iPhone 5"}
//        if platform == "iPhone5,3" { return "iPhone 5C"}
//        if platform == "iPhone5,4" { return "iPhone 5C"}
//        if platform == "iPhone6,1" { return "iPhone5S"}
//        if platform == "iPhone6,2" { return "iPhone5S"}
//        if platform == "iPhone7,1" { return "iPhone6Plus"}
//        if platform == "iPhone7,2" { return "iPhone6"}
//        if platform == "iPhone8,1" { return "iPhone6S"}
//        if platform == "iPhone8,2" { return "iPhone6SPlus"}
//        if platform == "iPhone8,4" { return "iPhoneSE"}
//        if platform == "iPhone9,1" { return "iPhone7"}
//        if platform == "iPhone9,2" { return "iPhone7Plus"}
//        if platform == "iPhone10,1" { return "iPhone8"}
//        if platform == "iPhone10,2" { return "iPhone8Plus"}
//        if platform == "iPhone10,3" { return "iPhoneX"}
//        if platform == "iPhone10,4" { return "iPhone8"}
//        if platform == "iPhone10,5" { return "iPhone8Plus"}
//        if platform == "iPhone10,6" { return "iPhoneX"}
//
//        if platform == "iPod1,1" { return "iPod Touch 1G"}
//        if platform == "iPod2,1" { return "iPod Touch 2G"}
//        if platform == "iPod3,1" { return "iPod Touch 3G"}
//        if platform == "iPod4,1" { return "iPod Touch 4G"}
//        if platform == "iPod5,1" { return "iPod Touch 5G"}
//
//        if platform == "iPad1,1" { return "iPad 1"}
//        if platform == "iPad2,1" { return "iPad 2"}
//        if platform == "iPad2,2" { return "iPad 2"}
//        if platform == "iPad2,3" { return "iPad 2"}
//        if platform == "iPad2,4" { return "iPad 2"}
//        if platform == "iPad2,5" { return "iPad Mini 1"}
//        if platform == "iPad2,6" { return "iPad Mini 1"}
//        if platform == "iPad2,7" { return "iPad Mini 1"}
//        if platform == "iPad3,1" { return "iPad 3"}
//        if platform == "iPad3,2" { return "iPad 3"}
//        if platform == "iPad3,3" { return "iPad 3"}
//        if platform == "iPad3,4" { return "iPad 4"}
//        if platform == "iPad3,5" { return "iPad 4"}
//        if platform == "iPad3,6" { return "iPad 4"}
//        if platform == "iPad4,1" { return "iPad Air"}
//        if platform == "iPad4,2" { return "iPad Air"}
//        if platform == "iPad4,3" { return "iPad Air"}
//        if platform == "iPad4,4" { return "iPad Mini 2"}
//        if platform == "iPad4,5" { return "iPad Mini 2"}
//        if platform == "iPad4,6" { return "iPad Mini 2"}
//        if platform == "iPad4,7" { return "iPad Mini 3"}
//        if platform == "iPad4,8" { return "iPad Mini 3"}
//        if platform == "iPad4,9" { return "iPad Mini 3"}
//        if platform == "iPad5,1" { return "iPad Mini 4"}
//        if platform == "iPad5,2" { return "iPad Mini 4"}
//        if platform == "iPad5,3" { return "iPad Air 2"}
//        if platform == "iPad5,4" { return "iPad Air 2"}
//        if platform == "iPad6,3" { return "iPad Pro 9.7"}
//        if platform == "iPad6,4" { return "iPad Pro 9.7"}
//        if platform == "iPad6,7" { return "iPad Pro 12.9"}
//        if platform == "iPad6,8" { return "iPad Pro 12.9"}
//
//        if platform == "i386"   { return "iPhone Simulator"}
//        if platform == "x86_64" { return "iPhone Simulator"}
//
        return platform
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
