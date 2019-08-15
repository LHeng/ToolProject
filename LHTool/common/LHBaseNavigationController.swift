//
//  LHBaseNavigationController.swift
//  LHTool
//
//  Created by 刘恒 on 2018/7/24.
//  Copyright © 2018年 LH. All rights reserved.
//

import UIKit

class LHBaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //bar backgroud color
        self.navigationBar.barTintColor = UIColor.orange
//        self.navigationBar.barStyle = UIBarStyle.black
        //no translucent
        self.navigationBar.isTranslucent = false
        //back button and such
        self.navigationBar.tintColor = UIColor.white
        //title's text color
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationBar.shadowImage = UIImage()
//        navigationBar.setBackgroundImage(UIImage(), for: .default)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
