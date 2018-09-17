//
//  LHSingleChooseVC.swift
//  LHTool
//
//  Created by 刘恒 on 2018/7/18.
//  Copyright © 2018年 LH. All rights reserved.
//

import UIKit

class LHSingleChooseVC: LHBaseViewController {

    @IBOutlet weak var myTableView: UITableView!
    
    var isChoose : Int = -1
    var arr : [Bool] = [Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 0..<40 {
            arr.append(false)
        }
        myTableView.register(UINib.init(nibName: "LHMyTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "cell")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


//MARK: UITableViewDataSource&&UITableViewDelegate
extension LHSingleChooseVC : UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : LHMyTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LHMyTableViewCell
        if isChoose == indexPath.row {
            arr[indexPath.row] = true
        } else {
            arr[indexPath.row] = false
        }
        cell.myLabel.text = String.init(format: "%ld", indexPath.row)
        cell.isChoose = arr[indexPath.row]
        cell.myButton.tag = indexPath.row
        cell.myBlock = {(choose,index) in
            if choose {
                self.isChoose = index
            } else {
                self.isChoose = -1
            }
            self.myTableView.reloadData()
            print(choose)
            print(indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
}
