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
    var m_objCurData:AdvData? = nil;
    //菊花
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    //获取广告列表
    func getAdvList() {
        
        m_vAdvList = [];
        
        let channelType = Channel.ZIYOU.rawValue
        let systemType = PlateForm.IOS.rawValue
        let phoneType = CommonFunc.getDeviceEx();
        let url = Constants.m_baseUrl + "app/channelAdverInfo/getAdverList?channelType=" + channelType + "&systemType=" + systemType + "&phoneType=" + phoneType + "&userAppId=" + UserInfo.shared.m_strUserAppId;
        
        self.play();
        Alamofire.request(url).responseJSON {response in
            
            NetCtr.parseResponse(view: self, response: response, successHandler:{
                obj,msg in
                let array = obj["result"] as! Array<AnyObject>
                
                self.m_vAdvList = [];
                
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
//                    data.setDayStart(str: item["adverDayStart"] as! String);
                    data.setRemainNum(remain: (item["adverCountRemain"] as AnyObject).stringValue);
                    data.setImg(img: item["adverImg"] as! String);
                    data.setBundleId(bundleid: item["bundleId"] as! String);
                    data.setTaskType(tasktype: item["taskType"] as! String);
                    data.setTimeLimit(timeLimit: (item["timeLimit"] as! AnyObject).stringValue);
                    self.m_vAdvList.append(data);
                }
            })
            
            self.tableView.reloadData();
            self.refreshControl!.endRefreshing();
            self.stop();
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
        
        let url = Constants.m_baseUrl + "app/duijie/lingQuRenWu?adid=" + adid + "&idfa=" + idfa + "&ip=" + ip + "&userAppId=" + userappid + "&adverId=" + adverid + "&appleId=" + UserInfo.shared.m_strAppId + "&userNum" + UserInfo.shared.m_strUserNum;
        
        Alamofire.request(url).responseJSON {response in
            NetCtr.parseResponse(view: self, response: response, successHandler:{
                obj,msg in
                callBack();
        
                if let json = response.result.value
                {
                    let tmp = json as! [String : AnyObject]
                    let msg = tmp["msg"] as! String;
                    
                    if(msg != "你已成功领取任务，不需重复领取！")
                    {
                        //领取任务的开始时间
                        let nowTime = CommonFunc.getNowTime();
                        data.setDayStart(str: nowTime);
            
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let strNowTime = formatter.string(from: nowTime);
                        //存储领取任务的时间
                        let insertSQL = "INSERT INTO 't_AdvDate' (AdverId,start_time) VALUES ('\(adverid)','\(strNowTime)');"
                        
                        if SQLiteManager.shareInstance().execSQL(SQL: insertSQL) {
                            print("插入领取任务时间成功")
                        }else{
                            print("插入领取任务时间失败")
                        }
                        
                    }else{
                        //读取数据库
                        let querySQL = "SELECT AdverId,start_time FROM 't_AdvDate' WHERE AdverId = \(adverid)"
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
        self.initScroll();
        
        self.initIndicator();
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        CommonFunc.log("self.m_vAdvList.count",self.m_vAdvList.count)
        if (self.m_vAdvList.count > 9)
        {
            print("")
        }
        return self.m_vAdvList.count;
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //1创建cell
        let identifier : String = "CellViewIdentifier"
        var cell:CellView = tableView.dequeueReusableCell(withIdentifier: identifier) as! CellView
        if cell == nil {
            //在swift中使用枚举类型方式 1>枚举类型.具体类型  2> .具体类型
            cell = CellView(style: UITableViewCellStyle.value1, reuseIdentifier: identifier)
        }
        //2设置数据
        if (indexPath.row <= self.m_vAdvList.count)
        {
            let objData = self.m_vAdvList[indexPath.row];
            let strName = objData.m_strName
            let strPrice = objData.m_strPrice
            var strRemain = objData.m_strRemainNum
            if strRemain == nil
            {
                strRemain = "0";
            }
        
        
        
            cell.tf_name.text = strName;
            cell.tf_num.text = "剩" + strRemain! + "份";
        
            cell.tf_money.attributedText = CommonFunc.money(money: strPrice, pluesize: 13.0, numsize: 17.0, yuansize: 13.0);
        
        
//        //获取当前时间
//        let now = NSDate()
//        
//        // 创建一个日期格式器
//        let dformatter = DateFormatter()
//        dformatter.dateFormat = "HH_mm_ss"
//        
//        //当前时间的时间戳
//        let timeInterval:TimeInterval = now.timeIntervalSince1970
//        let timeStamp = String(timeInterval)
//        let savePath = "imgs/" + timeStamp + "/" + objData.m_strImgUrl;

          let url_str = Constants.m_baseUrl + "file/adver/img/" + objData.m_strImgUrl;
        //let url = "http://imgsrc.baidu.com/imgad/pic/item/caef76094b36acaf0accebde76d98d1001e99ce7.jpg"
//        CommonFunc.log(url);
//        CommonFunc.download(url: url, save: savePath, callBack: {
//            (imagePath) in
//            CommonFunc.log(imagePath);
//            objData.setImgFilePath(path: imagePath);
//            cell.img_icon.image = UIImage(named: imagePath);
//        })
            let url = URL(string: url_str)
            cell.img_icon.kf.setImage(with: url)
            //绑定data
            cell.m_objData = objData;
        }
        //3返回cell
        
        return cell//在这个地方返回的cell一定不为nil，可以强制解包
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! CellView;
        let objData = cell.m_objData;

        m_objCurData = objData;
        
        lingqurenwu(data:objData!, callBack: {self.performSegue(withIdentifier: "detail", sender: self)});
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let destinationView = segue.destination as! AdvDetail
        
        destinationView.m_objData = m_objCurData

    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
