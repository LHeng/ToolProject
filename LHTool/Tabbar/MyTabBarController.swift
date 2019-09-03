//
//  MyTabBarController.swift
//  TestDemo
//
//  Created by 刘恒 on 2019/3/13.
//

import UIKit

protocol MyTarBarControllerDelegate : NSObjectProtocol {
    func myTabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController)
}

class MyTabBarController: UITabBarController,UITabBarControllerDelegate {

    var myTabBar = MyTabbar(frame: CGRect.zero)
    weak var myDelegate : MyTarBarControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        myTabBar.centerBtn.addTarget(self, action: #selector(centerBtnAction), for: .touchUpInside)
        self.setValue(myTabBar, forKeyPath: "tabBar")
        self.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        myTabBar.centerBtn.isSelected = (tabBarController.selectedIndex == (viewControllers?.count)!/2)
        self.myDelegate?.myTabBarController(tabBarController, didSelect: viewController)
    }
    // 中间按钮点击
    @objc func centerBtnAction() {
        let count = viewControllers?.count ?? 0
        self.selectedIndex = count/2 // 关联中间按钮
        self.tabBarController(self, didSelect: viewControllers![selectedIndex])
    }
}

