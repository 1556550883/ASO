//
//  MyTableTableViewController.swift
//  mySolution
//
//  Created by dudu on 17/6/1.
//  Copyright © 2017年 bitse. All rights reserved.
//


import Alamofire
import UIKit
import Kingfisher

class AdvView: UITableViewController {
    
    var m_vAdvList:[AdvData]! = [];
    var m_vAdvListing:[AdvData]! = [];
    var m_objCurData:AdvData? = nil;
    
    var datemmmmmm:Date!;
    //菊花
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    //获取广告列表
    @objc func getAdvList() {
  
        m_vAdvList = [];
        requestInfo()
        let channelType = Channel.ZIYOU.rawValue
        let systemType = PlateForm.IOS.rawValue
        let phoneType = CommonFunc.getDeviceEx();
        let url = Constants.m_baseUrl + "app/channelAdverInfo/getAdverList?channelType=" + channelType + "&systemType=" + systemType + "&phoneType=" + phoneType + "&userAppId=" + UserInfo.shared.m_strUserAppId + "&osversion=" + UserInfo.shared.m_sys_version;
        print(url)
        self.play();
        
        Alamofire.request(url).responseJSON {response in
            NetCtr.parseResponse(view: self, response: response, successHandler:{
                result,obj,msg in

                let timeStr = obj["flag"] as! String;
                
                let dateFormatter1 = DateFormatter()
                dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let time = dateFormatter1.date(from: timeStr);
                UserInfo.shared.setcurrentTime(currentTime: time!);
                
                let array = obj["result"] as! Array<AnyObject>
                
                self.m_vAdvList = [];
                self.m_vAdvListing = []
               
                for item in array
                {
                    let data = AdvData();
                    CommonFunc.log(item)
                    
                    
                    data.setAdId(id: item["adid"] as! String);
                    data.setUrl(url: item["fileUrl"] as! String);
                    data.setName(name: item["adverName"] as! String);
                    data.setAdverId(id: (item["adverId"] as AnyObject).stringValue);
                    data.setDes(des: item["adverDesc"] as! String);
                    data.setPrice(price: (item["adverPrice"] as AnyObject).stringValue);
//                    data.setDayEnd(str: item["adverDayEnd"] as! String);
                    data.setDayStartTime(str: item["adverDayStart"] as! String);
                    data.setRemainNum(remain: (item["adverCountRemain"] as AnyObject).stringValue);
                    data.setImg(img: item["adverImg"] as! String);
                    data.setBundleId(bundleid: item["bundleId"] as! String);
                    data.setTaskType(tasktype: item["taskType"] as! String);
                    data.setTimeLimit(timeLimit: (item["timeLimit"] as! AnyObject).stringValue);
                    data.setExpTime(time: (item["openTime"] as AnyObject).uintValue);
                    data.setRemark(remark:item["remark"] as! String);

                        if(self.comePare(timeStr: item["adverDayStart"] as! String)){
                         
                            self.m_vAdvList.append(data);
                            
                        }else{
                        
                            self.m_vAdvListing.append(data)
                        }
                }
                let mmm = self.m_vAdvList.count + self.m_vAdvListing.count
                if(mmm == 0){
                   CommonFunc.alert(view: self, title: "提示", content: "无任务", okString: "知道了")
                }
                
                
            })
            
            self.tableView.reloadData();
            self.refreshControl!.endRefreshing();
            self.stop();
        }
    }
    
    func requestInfo()
    {
        let aUrl = Constants.m_baseUrl + "/app/duijie/getSystemParameter";
        Alamofire.request(aUrl).responseJSON {
            response in
            NetCtr.parseResponse(view: self, response: response, successHandler:
                {
                    result,obj,msg in
                    print(obj,result,msg)
                    //                    self.tongzhi = obj["notice"] as! String
                    let LeastMoney = obj["leastForward"]?.floatValue;
                    UserInfo.shared.setLeastMoney(LeastMoney: LeastMoney!)
                    
                    let isTixian = obj["leastForward"]?.floatValue;
                    UserInfo.shared.setisTixian(isTixian: isTixian!)
                    
                    let shareUrl = obj["downloadUrl"] as! String
                    
                    UserInfo.shared.setShareUrl(ShareUrl: shareUrl)
                    
                    let tongzhi = obj["notice"] as! String
                    
                    UserInfo.shared.setTongzhi(tongzhi: tongzhi)
                    
                    let idfaCheck = obj["idfaCheck"] as! String
                    UserInfo.shared.setIdfaCheck(idfaCheck: idfaCheck)
            })
        }
    }
    
    //领取任务
    func lingqurenwu(data:AdvData, callBack:@escaping () -> ()){
        self.play();
        let idfa = CommonFunc.getIDFA();
        let ip = CommonFunc.getPubIp();
        let adid = data.m_strAdId
        let adverid = data.m_strAdverId
        let userappid = UserInfo.shared.m_strUserAppId
        let bundleid = data.m_strBundleId
        let workTime = data.m_timeLimit;
        let remainNum = Int(data.m_strRemainNum);
        
//        if(idfa != UserInfo.shared.m_idfa && UserInfo.shared.m_idfaCheck == "0"){
//            self.stop();
//            CommonFunc.alert(view: self, title: "警告", content: "无效idfa！", okString: "了解", okHandler:{
//                action in
//            })
//            return
//        }
        
        //判断是否已经存在了app,先判断是否接了任务
        let querySQL = "SELECT AdverId,idfa,start_time,complete_time FROM 't_AdvDate' where AdverId = '\(adverid)'  and idfa = '\(idfa)'"
        //取出数据库中用户表所有数据
        let result = SQLiteManager.shareInstance().queryDBData(querySQL: querySQL)
       
        if(result == nil || result?.count == 0){
            let isExisted = CommonFunc.openApp(bundleid:bundleid)
            if(isExisted)
            {
                self.stop();
                CommonFunc.alert(view: self, title: "警告", content: "此app已经存在，请先卸载！", okString: "了解", okHandler:{
                    action in
                })
                
                return
            }
            
            if(remainNum! <= 0){
                self.stop();
                CommonFunc.alert(view: self, title: "提示", content: "任务被抢光了！", okString: "了解", okHandler:{
                    action in
                })
                return
            }
        }else{
            //存在已接的任务
             let advDate = result?.first
             let strNowTime = advDate!["start_time"] as! String;
             let timeFormatter = DateFormatter()
             timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
             let nowtime = timeFormatter.date(from: strNowTime);//开始时间
             let strCompleteTime = advDate!["complete_time"] as! String;//结束时间
            //如果true、说明任务还未结束 否则任务已经完成
            if(strCompleteTime == "0000"){
                self.stop();
                data.setDayStart(str: nowtime!);
                let endTime = CommonFunc.getNowTime();
                let interval = CommonFunc.getTimeInterval(create_time: nowtime!, end_time: endTime, limitTime: workTime);
                if(interval == "0"){
                 //说明任务超时
                    self.stop();
                    CommonFunc.alert(view: self, title: "提示", content: "任务已超时！", okString: "了解", okHandler:{
                        action in
                    })
                    return
                }
                callBack();
                return
            }else{
                self.stop();
                CommonFunc.alert(view: self, title: "提示", content: "任务已完成！", okString: "了解", okHandler:{
                    action in
                })
                
                return
            }
        }
        
        let system = ShowMessage.iphoneType();
        let systemVersion = UIDevice.current.systemVersion
        
        let url = Constants.m_baseUrl + "app/duijie/lingQuRenWu?adid=" + adid + "&idfa=" + idfa + "&ip=" + ip + "&userAppId=" + userappid + "&adverId=" + adverid + "&appleId=" + UserInfo.shared.m_strAppId + "&userNum=" + UserInfo.shared.m_strUserNum + "&phoneModel=" + system + "&phoneVersion=" + systemVersion;
        
       Alamofire.request(url).responseJSON {response in
            NetCtr.parseResponse(view: self, response: response, successHandler:{
                result,obj,msg in
                
                callBack();
        
                if let json = response.result.value
                {
                    let tmp = json as! [String : AnyObject]
                    let msg = tmp["msg"] as! String;
                    if(msg != "你已成功领取任务，不需重复领取！"){
                        //领取任务的开始时间
                        let nowTime = CommonFunc.getNowTime();
                        data.setDayStart(str: nowTime);
            
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let strNowTime = formatter.string(from: nowTime);
                        //存储领取任务的时间
                        let insertSQL = "INSERT INTO 't_AdvDate' (AdverId,idfa,start_time, complete_time) VALUES ('\(adverid)','\(idfa)','\(strNowTime)', '0000');"
                        
                        if SQLiteManager.shareInstance().execSQL(SQL: insertSQL) {
                            print("插入领取任务时间成功")
                        }else{
                            print("插入领取任务时间失败")
                        }
                    }else{
                        //读取数据库
                        let querySQL = "SELECT AdverId,idfa,start_time FROM 't_AdvDate' WHERE AdverId = '\(adverid)'  and idfa = '\(idfa)'"
                        //取出数据库中用户表所有数据
                        let result = SQLiteManager.shareInstance().queryDBData(querySQL: querySQL)
                        if(result != nil && result?.count != 0)
                        {
                            let advDate = result?.first
                            
                            let strNowTime = advDate!["start_time"] as! String;
                            
                            let timeFormatter = DateFormatter()
                            
                            timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

                            let time = timeFormatter.date(from: strNowTime);
                            
                            data.setDayStart(str: time!);
                        }else{
                            //默认当前时间
                            let strNowTime = CommonFunc.getNowTime();
                            data.setDayStart(str: strNowTime);
                        }
                    }
                }
            })
            
            self.stop();
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(false, animated:false)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let button = UIButton(frame: CGRect(x:0,y:0,width:15,height:20))
        button.setBackgroundImage(UIImage(named:"push"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(pushback), for: UIControlEvents.touchUpInside)
        let item = UIBarButtonItem(customView:button)
        
        self.navigationItem.leftBarButtonItem = item

        self.initScroll();
        
        self.initIndicator();
        
        self.tableView.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1.0)
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.separatorColor = UIColor.clear

        
    }
    @objc func pushback(){
        self.navigationController?.popViewController(animated: true)
    }
    func initScroll() -> Void {
        getAdvList();
        self.refreshControl = UIRefreshControl()
        
        self.refreshControl?.addTarget(self, action: #selector(getAdvList), for: .valueChanged)
        self.refreshControl!.attributedTitle = NSAttributedString(string: "下拉刷新数据")
    }
    
    func initIndicator() {
        activityIndicator.center = self.view.center;
        //在view中添加控件activityIndicator
        self.view.addSubview(activityIndicator)
    }
    
    //菊花转动开始
    func play()
    {
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false;
    }
    
    //菊花转动结束
    func stop()
    {
        activityIndicator.stopAnimating()
        self.view.isUserInteractionEnabled = true;
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getDate()
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (section == 0) {
            return self.m_vAdvListing.count;
        }
    
        return self.m_vAdvList.count;
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //1创建cell
        let identifier : String = "CellViewIdentifier"
        let cell:CellView = tableView.dequeueReusableCell(withIdentifier: identifier) as! CellView
       cell.selectionStyle = UITableViewCellSelectionStyle.none
        //2设置数据
        if (indexPath.section == 0) {
            if (indexPath.row <= self.m_vAdvListing.count)
            {
                let objData = self.m_vAdvListing[indexPath.row];
                let strName = objData.m_strName
                let strPrice = objData.m_strPrice
                let type = objData.m_strTaskType
                let remark = objData.m_remark;
                var strRemain = objData.m_strRemainNum
                if strRemain == nil
                {
                    strRemain = "0";
                }
                
                let ns1=(strName as NSString).substring(from: 1)
                let ns2=(strName as NSString).substring(to: 1)

                cell.tf_name.text = ns2 + "****";

                cell.tf_num.text = "数量:" + strRemain!;
                
                var strType = "";
                if(type == "0")
                {
                    strType = "快速任务";
                }
                else if(type == "1")
                {
                    strType = "回调任务";
                }
                else
                {
                    strType = "快速任务";
                }
                
                //cell.remark.text =
                cell.tf_Type.text = strType
                if(remark != ""){
                      cell.remark.text = "(" + remark + ")"
                }else{
                     cell.remark.text = remark
                }
                
                cell.tf_money.text = "+"+strPrice+"元"
                
                let url_str = Constants.m_baseUrl + "file/adver/img/" + objData.m_strImgUrl;
                let url = URL(string: url_str)
                cell.img_icon.kf.setImage(with: url)
                //绑定data
                cell.m_objData = objData;
            }
        }else if(indexPath.section == 1){
            if (indexPath.row <= self.m_vAdvList.count)
            {
                let objData = self.m_vAdvList[indexPath.row];
                let strName = objData.m_strName
                let strPrice = objData.m_strPrice
                let type = objData.m_strTaskType
                let remark = objData.m_remark;
                var strRemain = objData.m_strRemainNum
//                if Int(strRemain!)! > 100
//                {
//                    cell.tf_num.text = "多量";
//                }else{
//                    cell.tf_num.text = "少量";
//                }
                //cell.tf_num.text = strRemain;
                cell.tf_num.text = "数量:" + strRemain!;
               
                print(strRemain)
                let ns2=(strName as NSString).substring(to: 1)
                print(ns2)
                
                cell.tf_name.text = ns2 + "****";
//                cell.tf_num.text = "剩" + strRemain! + "份";
                var strType = "";
                if(type == "0")
                {
                    strType = "快速任务";
                }
                else if(type == "1")
                {
                    strType = "回调任务";
                }
                else
                {
//                    strType = "自由任务";
                    strType = "快速任务";
                }
                
//                cell.tf_Type.text = strType
                cell.tf_Type.text = objData.m_AdverDaystart;
                //cell.remark.text = remark
                
                if(remark != ""){
                    cell.remark.text = "(" + remark + ")"
                }else{
                    cell.remark.text = remark
                }
             
                cell.tf_money.text = "+"+strPrice+"元"
                cell.img_icon.image = UIImage(named:"1.jpg")
                //绑定data
                cell.m_objData = objData;
            }
        }
        return cell//在这个地方返回的cell一定不为nil，可以强制解包
    }
  override  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView();
       view.backgroundColor = UIColor.clear
    let titleLaber = UILabel(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 15))
    titleLaber.backgroundColor = UIColor.clear
    view.addSubview(titleLaber)
    
    let label = UILabel(frame:CGRect(x:0,y:15,width:SCREEN_WIDTH,height:30));
    label.backgroundColor = UIColor.white
        label.text = "     进行中"
    if section == 1 {
        label.text = "     即将开始"
    }
    label.font = UIFont.systemFont(ofSize: 14)
        view.addSubview(label)
        
        return view
        
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0 && self.m_vAdvListing.count == 0){
            return 0;
        }else if(section == 1 && self.m_vAdvList.count == 0)
        {
            return 0;
        }
        
        return 45;
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(UserInfo.shared.m_NumType != 2){
            if (indexPath.section == 1) {
                CommonFunc.alert(view: self, title: "提示", content: "请耐心等待，任务还没开始", okString: "知道了")
            }else{
                let cell = tableView.cellForRow(at: indexPath) as! CellView;
                let objData = cell.m_objData;
                
                m_objCurData = objData;
                
                lingqurenwu(data:objData!, callBack: {self.performSegue(withIdentifier: "taskDetail", sender: self)});
            }
        }else{
            CommonFunc.alert(view: self, title: "提示", content: "请先绑定您的微信和手机号码！", okString: "知道了")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let destinationView = segue.destination as! AdvDetail
        
        destinationView.m_objData = m_objCurData

    }
    
    func comePare(timeStr:String)-> Bool{
 
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let time = dateFormatter1.date(from: timeStr);
        let date:Date = UserInfo.shared.m_currentTime;
        
        if date.compare(time!) == ComparisonResult.orderedAscending {
            print("createdAtDate > nowDate")//左操作数比右操作数小
            return true
        }
        
        if date.compare(time!) == ComparisonResult.orderedDescending {
            print("createdAtDate < nowDate")//左操作数比右操作数大
            return false
        }
        
    return true
        
    }
    
    func getDate(){
        let urlString = "http://m.baidu.com"

        let task = URLSession(configuration: URLSessionConfiguration.default).dataTask(with: URL(string: urlString)!) { (data, response, error) in

            if let httpresponse = response as? HTTPURLResponse {
                
                var dateString = httpresponse.allHeaderFields["Date"] as? String
                
                dateString = dateString?.substring(from: (dateString?.characters.index((dateString?.startIndex)!, offsetBy: 5))!)
                
                dateString = dateString?.substring(to: (dateString?.characters.index((dateString?.endIndex)!, offsetBy: -4))!)
                
                print(dateString)
                
                let datefmt = DateFormatter()
                datefmt.locale = Locale(identifier: "en_US")
                datefmt.dateFormat = "dd MMM yyyy HH:mm:ss"

                let date = datefmt.date(from: dateString!)?.addingTimeInterval(60*60*8)
                print(date)
                
                let zone = NSTimeZone.system
                
                let inter = zone.secondsFromGMT(for: date!)
                let locadate = date?.addingTimeInterval(TimeInterval(inter))
                print(locadate)

               self.datemmmmmm = locadate;
            }
        }
        task.resume()
    }
}
