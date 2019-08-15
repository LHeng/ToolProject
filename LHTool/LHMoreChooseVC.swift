//
//  LHMoreChooseVC.swift
//  LHTool
//
//  Created by 刘恒 on 2018/7/18.
//  Copyright © 2018年 LH. All rights reserved.
//

import UIKit

class LHMoreChooseVC: LHBaseViewController {

    var arr : [Bool] = [Bool]()

    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for _ in 0..<40 {
            arr.append(false)
        }
        
        myTableView.register(UINib.init(nibName: "LHMyTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "cell")
        
        // Do any additional setup after loading the view.
    }

    @IBAction func ButtonEvent(_ sender: Any) {
        switch (sender as AnyObject).tag {
        case 101://多选
            for i in 0..<40 {
                arr[i] = true
            }
            break
        case 102://反选
            for i in 0..<40 {
                arr[i] = !arr[i]
            }
            break
        default:
            break
        }
        myTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK: UITableViewDataSource&&UITableViewDelegate
extension LHMoreChooseVC : UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : LHMyTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LHMyTableViewCell
        cell.myLabel.text = String.init(format: "%ld", indexPath.row)
        cell.isChoose = arr[indexPath.row]
        cell.myButton.tag = indexPath.row
        cell.selectionStyle = .none
        cell.myBlock = {(choose,index) in
            if choose {
                self.arr[index] = choose
            } else {
                self.arr[index] = choose
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
