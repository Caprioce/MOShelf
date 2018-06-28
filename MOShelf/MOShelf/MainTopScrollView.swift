//
//  MainTopScrollView.swift
//  Hupu
//
//  Created by 张驰 on 2018/6/27.
//  Copyright © 2018年 张驰. All rights reserved.
//

import UIKit

protocol MainTopScrollViewDelegate {
    
    func didSelectMenuBtn(index:Int)
    
}

class MainTopScrollView: UIView,UIScrollViewDelegate {
    
    let MainTitlePadding = CGFloat(10.0)
    
    var titleArr:[String]?
    var titleLength:[CGFloat]? = []
    
    var selectBtn:UIButton?
    var addBtn:UIButton?
    var line:UILabel?
    var scrollview:UIScrollView!
    var delegate:MainTopScrollViewDelegate?
    
    
    convenience init(frame:CGRect,titleArr:[String]){
        self.init(frame: frame)
        
        self.titleArr = titleArr
        
        makeUI()
    }
    
    //MARK:- Open Method
    func lineAnimation() {
        var offset = selectBtn!.center.x - scrollview.frame.width/2
        
        if offset < 0 {
            offset = 0
        }else if offset > scrollview.contentSize.width - scrollview.frame.width {
            offset = scrollview.contentSize.width - scrollview.frame.width
        }
        scrollview.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
    }
    
    func clickLineMove() {
        line?.frame = CGRect(x: selectBtn!.frame.minX + MainTitlePadding, y: line!.frame.minY, width: selectBtn!.frame.width-2*MainTitlePadding, height: line!.frame.height)
    }
    
    //MARK:- UI
    func makeUI() {
        scrollview = UIScrollView(frame: CGRect(x: 0, y: 0, width: frame.width-40, height: frame.height))
        scrollview.backgroundColor = UIColor.white
        scrollview.delegate = self
        scrollview.showsHorizontalScrollIndicator = false
        self.addSubview(scrollview)
        
        addBtn = UIButton(frame: CGRect(x: scrollview.frame.maxX, y: 0, width: 40, height: frame.height))
        addBtn?.setTitle("+", for: .normal)
        addBtn?.setTitleColor(UIColor.black, for: .normal)
        addSubview(addBtn!)
        
        //线
        let underLine = UILabel(frame: CGRect(x: 0, y: frame.maxY-0.5, width: frame.width, height: 0.5))
        underLine.backgroundColor = UIColor.UIColorFromRGB(rgbValue: 0xcccccc)
        addSubview(underLine)
        
        
        var x = 0.0
        
        for item in (titleArr?.enumerated())! {
            
            let btn = UIButton(frame: CGRect(x: x, y: 0, width: 1, height: 40))
            btn.setTitle(titleArr![item.offset], for: .normal)
            btn.setTitleColor(UIColor.black, for: .normal)
            btn.setTitleColor(mainColor, for: .selected)
            btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            btn.titleLabel?.textAlignment = .center
            btn.tag = 10+item.offset
            btn.sizeToFit()
            titleLength?.append(btn.frame.width)
            btn.frame = CGRect(x: x, y: 0.0, width: Double(btn.frame.width+2*MainTitlePadding), height: 40.0)
            btn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
            x = Double(btn.frame.maxX)
            scrollview.addSubview(btn)
            
            if item.offset == 0 {
                selectBtn = btn
                selectBtn?.isSelected = true
                
                line = UILabel(frame: CGRect(x: btn.frame.minX + MainTitlePadding, y: 37, width: btn.frame.width-2*MainTitlePadding, height: 3))
                line?.backgroundColor = mainColor
                scrollview.addSubview(line!)
            }
            
            if item.offset == titleArr!.count - 1{
                scrollview.contentSize = CGSize(width: btn.frame.maxX, height: 40)
            }
            
        }
        
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
    }
    
    //MARK:- Btn Action
    @objc func btnAction(_ btn:UIButton) {
        if delegate != nil {
            selectBtn?.isSelected = false
            selectBtn = btn
            selectBtn?.isSelected = true
            
            clickLineMove()
            lineAnimation()
            delegate!.didSelectMenuBtn(index: btn.tag-10)
        }
    }
}
