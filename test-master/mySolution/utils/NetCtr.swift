//
//  NetCtr.swift
//  mySolution
//
//  Created by dudu on 2017/8/12.
//  Copyright © 2017年 bitse. All rights reserved.
//

import AdSupport
import Foundation
import UIKit
import Alamofire
import CoreFoundation
class NetCtr
{
    private init(){};
    public static func parseResponse(view:UIViewController, response:DataResponse<Any>, successHandler:((Int,[String:AnyObject],String)->Void)? = nil,
                                     errorHandler:(()->Void)? = nil)->Void
    {
        if let json = response.result.value
        {
            let tmp = json as! [String : AnyObject]
            let msg = tmp["msg"] as! String;
            CommonFunc.log(tmp)
            let result = tmp["result"] as! Int
            if(result != -1)
            {
                let obj = tmp["obj"] as! [String:AnyObject]
                if (successHandler != nil)
                {
                    try? successHandler!(result, obj, msg)
                }
            }
            else
            {
                CommonFunc.alert(view: view, title: "失败！！", content: msg, okString: "知道了");
                if (errorHandler != nil)
                {
                    try? errorHandler!()
                }
            }
        }

    }
}
