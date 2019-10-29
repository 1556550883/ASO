//
//  JSShareItem.swift
//  ShareDemo
//
//  Created by Jesson on 2017/4/21.
//  Copyright © 2017年 Jesson. All rights reserved.
//

import UIKit

class JSShareItem: UIView {
    
    var itemClickBlock:((_ index:Int)->Void)?

    fileprivate var imageStr:String?
    fileprivate var text:String?
    fileprivate var index:Int?
    
    convenience init(frame:CGRect,image:String,text:String,index:Int){
        self.init(frame: frame)
        self.imageStr = image
        self.text = text
        self.index = index
        self.isUserInteractionEnabled = true
        let tapGes:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(itemClick))
        self.addGestureRecognizer(tapGes)
        self.setUI()
    }
    
}

extension JSShareItem{
    
    func setUI(){
        let image = UIImage.init(named: self.imageStr!)
        let imageSize = image!.size
        let itemWidth = SCREEN_WIDTH/4
        let imageView:UIImageView = UIImageView.init(frame: CGRect.init(x: (self.frame.size.width - 50)/2, y: 20, width:70, height: 70))
        imageView.image = UIImage.init(named: self.imageStr!)
        self.addSubview(imageView)
        let textLabel:UILabel = UILabel.init(frame: CGRect.init(x: 10, y: imageView.frame.origin.y+imageView.frame.size.height + 10, width: itemWidth, height: 13))
        textLabel.text = self.text
        textLabel.textAlignment = .center
        textLabel.textColor = UIColor.gray
        textLabel.font = UIFont.systemFont(ofSize: 13)
        self.addSubview(textLabel)
    }
    
    /// item的点击事件
    @objc func itemClick() {
        self.itemClickBlock?(self.index!)
    }
}
