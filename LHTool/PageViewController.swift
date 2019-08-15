//
//  PageViewController.swift
//  LHTool
//
//  Created by 刘恒 on 2019/8/7.
//  Copyright © 2019 LH. All rights reserved.
//

import UIKit

class PageViewController: LHBaseViewController,LHPageTabeViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        // Do any additional setup after loading the view.
    }

    private func initView() {
        let vc1 = makeVCWithColor(color: UIColor.red)
        let vc2 = makeVCWithColor(color: UIColor.orange)
        let vc3 = makeVCWithColor(color: UIColor.yellow)
        let vc4 = makeVCWithColor(color: UIColor.green)
        let vc5 = makeVCWithColor(color: UIColor.hexStringToColor(hexString: "#00FFFF"))
        let vc6 = makeVCWithColor(color: UIColor.blue)
        let vc7 = makeVCWithColor(color: UIColor.purple)

        addChildController(childControllers: [vc1,vc2,vc3,vc4,vc5,vc6,vc6,vc7])

        let pageTableView:LHPageTabeView = LHPageTabeView.init(childControllers: self.children, childTitles: ["红","橙","黄","绿","青","蓝","紫"])
        pageTableView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        pageTableView.titleStyle = .gradient
        pageTableView.indicatorStyle = .stretch
        pageTableView.delegate = self
        view.addSubview(pageTableView)
    }

    @objc func pageTabViewDidEndChange() {

    }
    private func makeVCWithColor(color: UIColor) -> UIViewController{
        let vc = UIViewController()
        vc.view.backgroundColor = color
        return vc
    }

    private func addChildController(childControllers:[UIViewController]) {
        for vc in childControllers {
            self.addChild(vc)
        }
    }
}
