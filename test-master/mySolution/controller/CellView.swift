//
//  CellView.swift
//  mySolution
//
//  Created by 战神 on 2017/6/4.
//  Copyright © 2017年 bitse. All rights reserved.
//

import UIKit

class CellView: UITableViewCell {
    @IBOutlet weak var tf_money: UILabel!
    @IBOutlet weak var tf_name: UILabel!
    @IBOutlet weak var img_icon: UIImageView!
    @IBOutlet weak var tf_num: UILabel!
    @IBOutlet var tf_Type: UILabel!
    var m_objData:AdvData? = nil;
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
//    override func prepareForReuse() {
//        for item in self.img_icon.subviews {
//            item.removeFromSuperview();
//        }
//    }
}
