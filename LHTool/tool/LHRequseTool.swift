//
//  LHRequseTool.swift
//  LHTool
//
//  Created by 刘恒 on 2018/6/28.
//  Copyright © 2018年 LH. All rights reserved.
//

import UIKit

class LHRequseTool: NSObject {
    class func requestCityList(method:RequestMethod,params:NSMutableDictionary,dataArr:NSMutableArray,success:@escaping (NSMutableArray)->(),failure:@escaping (Error)->()) -> Void {
        
        LHBaseHttps.shareLHBaseHttps.isNeedAccessToken = false
        LHBaseHttps.shareLHBaseHttps .RequestParams(url:"", method: method, params: params, success: { (respones) in
            print(respones)
            
            if respones is NSNumber {
                
                print("no success or no Data")
                
            } else {
                
                //解析数据
                //let cityList = Mapper<SSCityModel>().mapArray(JSONArray: respones as! [[String : Any]])
                
                //success(cityList!)
                
            }
            
        }) { (error) in
            print(error)
        }
        
    }
}
