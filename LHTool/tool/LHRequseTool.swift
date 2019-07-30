//
//  LHRequseTool.swift
//  LHTool
//
//  Created by 刘恒 on 2018/6/28.
//  Copyright © 2018年 LH. All rights reserved.
//

import UIKit

class LHRequseTool: NSObject {

    class func requestPost(url: String, params: NSDictionary, dataArr: NSMutableArray?, success: @escaping (Any?)->(), failure: @escaping (Error)->()) -> Void {
        
        LHBaseHttps.shareLHBaseHttps.isNeedAccessToken = false
        LHBaseHttps.shareLHBaseHttps.RequestParams(url: url, method: .RequestMethodPOST, params: params, success: { (respones) in
            print(respones ?? "")
            success(respones)
        }) { (error) in
            failure(error)
        }
    }

    class func requestGet(url: String, params: NSDictionary, dataArr: NSMutableArray?, success: @escaping (Any?)->(), failure: @escaping (Error)->()) -> Void {

        LHBaseHttps.shareLHBaseHttps.isNeedAccessToken = false
        LHBaseHttps.shareLHBaseHttps.RequestParams(url: url, method: .RequestMethodGET, params: params, success: { (respones) in
            print(respones ?? "")
            success(respones)

        }) { (error) in
            failure(error)
        }
    }
}
