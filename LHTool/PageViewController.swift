//
//  PageViewController.swift
//  LHTool
//
//  Created by 刘恒 on 2019/8/7.
//  Copyright © 2019 LH. All rights reserved.
//

import UIKit

class PageViewController: LHBaseViewController {

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

        self.addChild(vc1)
        self.addChild(vc2)
        self.addChild(vc3)
        self.addChild(vc4)
        self.addChild(vc5)
        self.addChild(vc6)
        self.addChild(vc7)

        let pageTableView = XXPageTabView.init(childControllers: self.children, childTitles: ["赤","橙","黄","绿","青","蓝","紫"])
        pageTableView?.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        pageTableView?.titleStyle  = .default
        pageTableView?.indicatorStyle = .default
        view.addSubview(pageTableView!)
    }

    private func makeVCWithColor(color: UIColor) -> UIViewController{
        let vc = UIViewController()
        vc.view.backgroundColor = color
        return vc
    }
}