//
//  ScoreCell.swift
//  mySolution
//
//  Created by dudu on 17/6/13.
//  Copyright © 2017年 bitse. All rights reserved.
//

import UIKit

class ScoreCell: UITableViewCell {
    @IBOutlet weak var tf_title: UILabel!
    @IBOutlet var tf_status: UILabel!
    @IBOutlet var tf_price: UILabel!
    @IBOutlet var tf_completeTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
