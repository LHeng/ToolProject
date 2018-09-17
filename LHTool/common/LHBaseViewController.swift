//
//  LHBaseViewController.swift
//  LHTool
//
//  Created by 刘恒 on 2018/7/19.
//  Copyright © 2018年 LH. All rights reserved.
//

import UIKit

class LHBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let left = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(onClickBack))
        self.navigationItem.leftBarButtonItem = left
        // Do any additional setup after loading the view.
    }

    @objc func onClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
