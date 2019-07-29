//
//  LHRequseTool.swift
//  LHTool
//
//  Created by 刘恒 on 2018/6/28.
//  Copyright © 2018年 LH. All rights reserved.
//

import UIKit

class LHRequseTool: NSObject {

    class func requestPost(method:RequestMethod,params:NSDictionary,dataArr:NSMutableArray,success:@escaping (NSMutableArray)->(),failure:@escaping (Error)->()) -> Void {
        
        LHBaseHttps.shareLHBaseHttps.isNeedAccessToken = false
        LHBaseHttps.shareLHBaseHttps.RequestParams(url:"http://zhanhui-background.phhyzy.com/robot/health/message", method: method, params: params, success: { (respones) in
            print(respones ?? "")

        }) { (error) in
            failure(error)
        }
    }
}
