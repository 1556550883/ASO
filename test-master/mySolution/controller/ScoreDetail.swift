//
//  ScoreDetail.swift
//  mySolution
//
//  Created by dudu on 17/6/13.
//  Copyright © 2017年 bitse. All rights reserved.
//

import UIKit
import Alamofire

class ScoreDetail: UITableViewController {
    //菊花
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(false, animated:false)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let button = UIButton(frame: CGRect(x:0,y:0,width:15,height:20))
        button.setBackgroundImage(UIImage(named:"push"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(pushback), for: UIControlEvents.touchUpInside)
        let item = UIBarButtonItem(customView:button)
        
        self.navigationItem.leftBarButtonItem = item
        
        self.tableView.separatorColor = UIColor.clear
        self.navigationItem.title = "收入明细"
        queryTaskSum()
    }
    @objc func pushback() {
        self.navigationController?.popViewController(animated: true)
    }
    func queryTaskSum(){
        self.play()
        let url = Constants.m_baseUrl + "app/duijie/queryTaskSum?idfa=" + CommonFunc.getIDFA();
        Alamofire.request(url).responseJSON {response in
            NetCtr.parseResponse(view: self, response: response, successHandler:{
                result, obj, msg in
                let array = obj["result"] as! Array<AnyObject>
                print(array)
                if(array.count == 0){
                    CommonFunc.alert(view: self, title: "还没有收入！！", content: "去赚钱！！！", okString: "去赚钱");
                }

                
                UserInfo.shared.setAdverInfo(vAdverInfo: array)
                self.tableView.reloadData();
                self.stop()
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(_ animated: Bool) {
        
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 9
        return UserInfo.shared.m_vAdverInfo.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //1创建cell
        let identifier : String = "scoredetailcell"
        let cell:ScoreCell = tableView.dequeueReusableCell(withIdentifier: identifier) as! ScoreCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        // Configure the cell...
        let adverinfo = UserInfo.shared.m_vAdverInfo[indexPath.row];
        
//        cell.tf_title.text = adverinfo["adverName"] as! String
        let price = adverinfo["adverPrice"] as? NSNumber
        
        
        
//        cell.tf_price.text = price?.stringValue
        cell.tf_price.text = "+" + price!.stringValue + "元"
        let status = adverinfo["status"] as! String
        var statusText = "none"
        if(status == "1")
        {
            statusText = "进行中..."
        }else if (status == "1.5")
        {
            statusText = "任务打开"
        }else if (status == "1.6")
        {
            statusText = "超时"
        }else if(status == "2")
        {
            statusText = "完成"
        }
        cell.tf_status.text = statusText
        if(status == "2")
        {
            cell.tf_completeTime.text = adverinfo["completeTime"] as? String
        }
        
        return cell
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
