//
//  TabBarViewController.swift
//  TestDemo
//
//  Created by 刘恒 on 2019/2/26.
//

import UIKit

class TabBarViewController: MyTabBarController,MyTarBarControllerDelegate {

    func myTabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 2 {
            UserDefaults.standard.setValue(NSNumber.init(value: tabBarController.selectedIndex), forKey: "lastSelectedIndex")
            rotationAnimation()
            self.dismiss(animated: true, completion: nil)
        }else {
            removeAnimation()
        }
    }

    // 旋转动画
    func rotationAnimation() {
        if "key" == self.myTabBar.centerBtn.layer.animationKeys()?.first {
            return
        }
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.toValue = NSNumber(value: Double.pi*2.0)
        animation.duration = 3.0
        animation.repeatCount = HUGE
        self.myTabBar.centerBtn.layer.add(animation, forKey: "key")
        myTabBar.centerBtn.isSelected = false
    }

    func removeAnimation() {
        myTabBar.centerBtn.isSelected = true
        self.myTabBar.centerBtn.layer.removeAllAnimations()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabbar()
        // Do any additional setup after loading the view.
    }

    func setUpTabbar(){
        //设置tabbar的背景颜色
        //选中时的颜色
        myTabBar.tintColor = UIColor(red: 255.0 / 255.0, green: 80.0 / 255.0, blue: 95.0 / 255.0, alpha: 1.0)
        //透明设置为NO，显示白色，view的高度到tabbar顶部截止，YES的话到底部
        myTabBar.isTranslucent = false
        myTabBar.positon = .bulge
        myTabBar.centerImage = UIImage(named: "tabbar_add_yellow")!
        self.myDelegate = self

        let vc1 = LHBaseNavigationController.init(rootViewController: PageViewController())
        vc1.tabBarItem.title = "第一页"
        vc1.tabBarItem.tag = 0

        let vc2 = LHBaseNavigationController.init(rootViewController: PageViewController())
        vc2.tabBarItem.title = "第二页"
        vc2.tabBarItem.tag = 1

        let vc3 = LHBaseNavigationController.init(rootViewController:  UIViewController())
        vc3.tabBarItem.title = "点击返回"
        vc3.tabBarItem.tag = 2

        let vc4 = LHBaseNavigationController.init(rootViewController: PageViewController())
        vc4.tabBarItem.title = "第四页"
        vc4.tabBarItem.tag = 3

        let vc5 = LHBaseNavigationController.init(rootViewController: PageViewController())
        vc5.tabBarItem.title = "第五页"
        vc5.tabBarItem.tag = 4

        self.viewControllers = [vc1,vc2,vc3,vc4,vc5]
    }
}

