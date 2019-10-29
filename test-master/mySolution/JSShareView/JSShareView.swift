//
//  JSShareView.swift
//  ShareDemo
//
//  Created by Jesson on 2017/4/20.
//  Copyright © 2017年 Jesson. All rights reserved.
//

import UIKit

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let VIEW_DURATION = 0.2 //动画时长
let BOTTOM_VIEW_HEIGHT:CGFloat = 250.0

class JSShareView: UIViewController {
    
    
    var itemClickBlock:((_ index:Int)->Void)?
    
    fileprivate var viewTitle:String?
    fileprivate var imageArray:NSArray?
    fileprivate var textArray:NSArray?
    
    
    /// 构建分享弹出视图
    ///
    /// - Parameters:
    ///   - title: 视图标题
    ///   - imageArray: item的image名称数组
    ///   - textArray: item的image下方的文字
    convenience init(title:String?,imageArray:[String]?,textArray:[String]?){
        self.init()
        self.viewTitle = title
        self.imageArray = imageArray! as NSArray
        self.textArray = textArray! as NSArray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isUserInteractionEnabled = true
        self.view.frame = CGRect.init(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
//        self.view.backgroundColor = UIColor.init(colorLiteralRed: 150/255.0, green: 150/255.0, blue: 150/255.0, alpha: 0.3)
        let tapGes:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        self.view.addGestureRecognizer(tapGes)
        
        if self.imageArray?.count == self.textArray?.count {
            if self.imageArray!.count > 8 {
                print("传入的个数不能大于8")
            }else{
                self.setUI()
            }
        }else{
            print("传入的图片数组数量和对应的文字数组数量不一致")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
}
extension JSShareView
{
    
    /// 设置界面UI
    func setUI() {
        
        let bgView:UIView = UIView.init(frame: CGRect.init(x: 5, y: SCREEN_HEIGHT-BOTTOM_VIEW_HEIGHT, width: SCREEN_WIDTH - 10, height: BOTTOM_VIEW_HEIGHT-20))
        
        bgView.clipsToBounds = false
        bgView.layer.cornerRadius = 20.0
        bgView.layer.rasterizationScale = UIScreen.main.scale
        bgView.layer.contentsScale =  UIScreen.main.scale
        
        bgView.backgroundColor = UIColor.white
        self.view.addSubview(bgView)
        
        let bgTitleLabel = UILabel.init(frame: CGRect.init(x: 0, y: 10, width: SCREEN_WIDTH, height: 15))
        bgTitleLabel.text = self.viewTitle
        bgTitleLabel.textAlignment = .center
        bgTitleLabel.font = UIFont.systemFont(ofSize: 14)
        bgTitleLabel.textColor = UIColor.gray
        bgView.addSubview(bgTitleLabel)
        
        let cancelBnt = UIButton.init(type: .custom)
        cancelBnt.frame = CGRect.init(x: 0, y: BOTTOM_VIEW_HEIGHT-44 - 20, width: SCREEN_WIDTH-10, height: 44)
        cancelBnt.setTitle("取消", for: .normal)
        cancelBnt.setTitleColor(UIColor.red, for: .normal)
        cancelBnt.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        cancelBnt.addTarget(self, action: #selector(tapAction), for: .touchUpInside)
        bgView.addSubview(cancelBnt)
        
        let image:UIImage = UIImage.init(named: self.imageArray?.firstObject as! String)!
        let itemWidth = SCREEN_WIDTH/4
        let itemHeight = 85
        for (index,value) in self.imageArray!.enumerated() {
            let text = self.textArray?.object(at: index)
            var item:JSShareItem?
            if index<4 {//第一排
                let js_x = Float(index) * Float(itemWidth + 10) + Float(10)
                item = JSShareItem.init(frame: CGRect.init(x: CGFloat(js_x), y: CGFloat(30), width: itemWidth, height: CGFloat(itemHeight)), image: value as! String, text: text as! String, index: index)
            }else{
                let js_x = Float(index-4) * Float(itemWidth)
                item = JSShareItem.init(frame: CGRect.init(x: CGFloat(js_x), y: CGFloat(40+70+15), width: itemWidth, height: CGFloat(itemHeight)), image: value as! String, text: text as! String, index: index)
            }
            bgView.addSubview(item!)
            item?.itemClickBlock = {(index) in
                self.itemClickWithIndex(index: index)
            }
        }
    }
    
    
    /// item的点击事件
    ///
    /// - Parameter index: index
    func itemClickWithIndex(index:Int){
        self.itemClickBlock?(index)
    }
    
    func show(){
        UIApplication.shared.keyWindow?.addSubview(self.view)
        UIView.animate(withDuration: VIEW_DURATION) {
            self.view.frame.origin.y = 0
        }
    }
    
    func dismiss(){
        UIView.animate(withDuration: VIEW_DURATION, animations: {
            self.view.frame.origin.y = SCREEN_HEIGHT
        }) { (bool) in
            self.removeFromParentViewController()
        }
    }
    
    @objc func tapAction() {
        self.dismiss()
    }
}
