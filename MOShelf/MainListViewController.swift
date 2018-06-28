//
//  MainListViewController.swift
//  Hupu
//
//  Created by 张驰 on 2018/6/27.
//  Copyright © 2018年 张驰. All rights reserved.
//

import UIKit

class MainListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableview:UITableView?
    var type:String?
    
    private var titleArr:[String] {
        get {
            let arr:[String]?
            switch type! {
            case "NBA":
                arr = ["恭喜WE","蔡卓妍发布新专辑","创造101赖美云","杨超越就是个弟弟"]
            case "足球":
                arr = ["足球"]
            case "英雄联盟":
                arr = ["英雄联盟"]
            case "绝地求生":
                arr = ["绝地求生"]
            case "中国篮球":
                arr = ["中国篮球"]
            case "耐克联赛":
                arr = ["耐克联赛"]
            case "赖美云":
                arr = ["赖美云"]
            case "吴宣仪":
                arr = ["吴宣仪"]
            case "宇多田光":
                arr = ["宇多田光"]
            default:
                arr = nil
            }
            return arr!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createTab()
    }

    func createTab() {
        
        tableview = UITableView(frame: CGRect(x: 0, y: 0, width: KSCREEN_WIDTH, height: KSCREEN_HEIGHT - NAV_HEIGHT - 40), style: .plain)
        tableview?.backgroundColor = defaultColor
        tableview?.delegate = self
        tableview?.dataSource = self
        tableview?.register(MainListTableViewCell.self, forCellReuseIdentifier: "MainListTableViewCell")
        tableview?.rowHeight = 100
        view.addSubview(tableview!)
    }
    
    func configImage() -> UIImage? {
        
        if type! == "NBA" {
            return UIImage(named: "default")!
        }else if type! == "足球" {
            return UIImage(named: "penhuolong")!
        }else if type! == "英雄联盟" {
            return UIImage(named: "jienigui")!
        }else{
            return UIImage(named: "pangding")!
        }
    }
    
    //MARK:- UITableview Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MainListTableViewCell = tableview?.dequeueReusableCell(withIdentifier: "MainListTableViewCell", for: indexPath) as! MainListTableViewCell
        cell.selectionStyle = .none
        cell.imageView?.image = configImage()
        cell.textLabel?.text = titleArr.count>1 ? titleArr[Int(arc4random()%UInt32(titleArr.count-1))] : titleArr[0]
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
