//
//  UserInfoCellTableViewCell.swift
//  mySolution
//
//  Created by dudu on 2017/9/3.
//  Copyright © 2017年 bitse. All rights reserved.
//

import UIKit

class UserInfoCell: UITableViewCell {
    @IBOutlet weak var m_img: UIImageView!

    @IBOutlet weak var m_label: UILabel!
    
    var m_data:UserBtnData!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
