//
//  HelpController.swift
//  mySolution
//
//  Created by 你若化成风 on 2018/5/16.
//  Copyright © 2018年 bitse. All rights reserved.
//

import UIKit

class HelpController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var help_tableView: UITableView!
    var titStr:[String] = ["1、需要帮助的问题1","2、需要帮助的问题1","3、需要帮助的问题1","4、需要帮助的问题内容特别长的时候，要限制字数吗？答案肯定的，不限制。"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1.0)
        
        self.navigationItem.setHidesBackButton(false, animated:false)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let button = UIButton(frame: CGRect(x:0,y:0,width:15,height:20))
        button.setBackgroundImage(UIImage(named:"push"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(pushback), for: UIControlEvents.touchUpInside)
        let item = UIBarButtonItem(customView:button)
        
        self.navigationItem.leftBarButtonItem = item
        
//        help_tableView.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1.0)
        help_tableView.dataSource = self;
        help_tableView.delegate = self;
        help_tableView.separatorColor = UIColor.clear
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    @objc func pushback(){
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier : String = "HelpViewCell"
        let cell:HelpViewCell = tableView.dequeueReusableCell(withIdentifier: identifier) as! HelpViewCell
        
        cell.titleLabel.text = titStr[indexPath.row]
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator//添加箭头
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row<3 {
            return 50
        }else{
            return 100
        }
        
    }
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
