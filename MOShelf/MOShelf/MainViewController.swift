//
//  MainViewController.swift
//  Hupu
//
//  Created by 张驰 on 2018/6/26.
//  Copyright © 2018年 张驰. All rights reserved.
//

import UIKit

enum MoveDirection {
    case moveLeft
    case moveRight
}

class MainViewController: UIViewController, UIScrollViewDelegate, MainTopScrollViewDelegate {
    
    var locationX : CGFloat = 0
    var config : MOShelfConfig!
    
    var scrollview:UIScrollView!
    var topView:MainTopScrollView!
    var controllerArr:[UIViewController] = []
    private var byDrag = false
    
    
    init(config:MOShelfConfig) {
        super.init(nibName: nil, bundle: nil)
        self.config = config
    }

    required init?(coder aDecoder: NSCoder) {
        self.config = MOShelfConfig()
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isTranslucent = false
        
        makeUI()
    }
    
    //MARK:- private Method
    func makeUI() {
        topView = MainTopScrollView(frame: CGRect(x: 0, y: 0, width: KSCREEN_WIDTH, height: 40), titleArr:config.titleArr!)
        topView.delegate = self
        view.addSubview(topView)
        
        scrollview = UIScrollView(frame: CGRect(x: 0, y: 40, width: KSCREEN_WIDTH, height: KSCREEN_HEIGHT - NAV_HEIGHT - 40))
        scrollview.backgroundColor = UIColor.white
        scrollview.delegate = self
        scrollview.contentSize = CGSize(width: KSCREEN_WIDTH*CGFloat(config.titleArr!.count), height: KSCREEN_HEIGHT - NAV_HEIGHT - 40 - TABBAR_HEIGHT)
        scrollview.bounces = false
        scrollview.isPagingEnabled = true
        view.addSubview(scrollview)
    
        //addChild
        for item in config.titleArr!.enumerated() {
            let vc = MainListViewController()
            vc.type = config.titleArr![item.offset]
            addChildViewController(vc)
            controllerArr.append(vc)

            if item.offset == 0 {
                vc.view.frame = CGRect(x: 0, y: 0, width: KSCREEN_WIDTH, height: KSCREEN_HEIGHT - NAV_HEIGHT - 40)
                scrollview.addSubview(vc.view)
            }
        }
    }
    
    //加载未加载的控制器
    func loadCachController(index:Int) {
        if index >= controllerArr.count {
            return
        }
        let VC : UIViewController = controllerArr[index]
        if !VC.isViewLoaded {
            VC.view.frame = CGRect(x: KSCREEN_WIDTH * CGFloat(index) , y: 0, width: KSCREEN_WIDTH, height: KSCREEN_HEIGHT - NAV_HEIGHT - 40)
            scrollview.addSubview(VC.view)
        }
    }
    
    //下标线的比例移动
    func underLineMove(direction:MoveDirection, index:Int, offset:CGFloat) {
        
        if index >= topView.titleLength!.count {
            return
        }
        
        var widthChange:CGFloat = 0
        var locationChange:CGFloat = 0
        
        if direction == .moveLeft { //左滑
            widthChange = topView.titleLength![index] - topView.titleLength![index-1]
            locationChange = topView.titleLength![index-1] + CGFloat(2 * config.MainTitlePadding)
        }else{
            widthChange = topView.titleLength![index] - topView.titleLength![index+1]
            locationChange = topView.titleLength![index] + CGFloat(2 * config.MainTitlePadding)
        }
        
        //宽度变化
        let percent = widthChange/KSCREEN_WIDTH
        let lengchange = offset * percent
        
        //中心变化
        let move = offset * locationChange/KSCREEN_WIDTH
        
        if direction == .moveLeft { //左滑
            let btn = topView.viewWithTag(10+index-1) as! UIButton
            topView.line?.frame = CGRect(x: btn.frame.minX + config.MainTitlePadding + move, y: topView.line!.frame.minY, width: btn.frame.width - 2*config.MainTitlePadding + lengchange, height: 3)
        }
        else{
            let btn = topView.viewWithTag(10+index+1) as! UIButton
            topView.line?.frame = CGRect(x: btn.frame.minX + config.MainTitlePadding - move, y: topView.line!.frame.minY, width: btn.frame.width - 2 * config.MainTitlePadding + lengchange, height: 3)
        }
    }
    
    //MARK:- MainTopScrollViewDelegate
    func didSelectMenuBtn(index: Int) {
        byDrag = false
        
        scrollview.contentOffset = CGPoint(x: KSCREEN_WIDTH * CGFloat(index), y: 0)
        topView.lineAnimation()
        loadCachController(index: index)
    }
    
    //MARK:- UIScrollview Delegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        byDrag = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !byDrag {
            return
        }

        var offset = scrollView.contentOffset.x.truncatingRemainder(dividingBy: KSCREEN_WIDTH)
        
        var index : Int
        
        //左滑
        if locationX < scrollView.contentOffset.x {
             index = Int(scrollView.contentOffset.x/KSCREEN_WIDTH)+1
             underLineMove(direction: .moveLeft, index: index, offset: offset)
        }//右滑
        else{
             index = Int(scrollView.contentOffset.x/KSCREEN_WIDTH)
             offset = KSCREEN_WIDTH - offset
             underLineMove(direction: .moveRight, index: index, offset: offset)
        }
        locationX = scrollView.contentOffset.x
        
        //加载第index个Controller
        loadCachController(index: index)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if !byDrag {
            return
        }
        
        let index = Int(scrollView.contentOffset.x/KSCREEN_WIDTH)
        
        let btn:UIButton = topView.viewWithTag(10 + index) as! UIButton
        topView.selectBtn?.isSelected = false
        topView.selectBtn = btn
        topView.selectBtn?.isSelected = true
        
        //停止滑动时 居中移动
        topView.lineAnimation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
