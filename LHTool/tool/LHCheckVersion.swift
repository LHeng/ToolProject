//
//  LHCheckVersion.swift
//  LHTool
//
//  Created by 刘恒 on 2018/8/10.
//  Copyright © 2018年 LH. All rights reserved.
//

import UIKit

class LHCheckVersion: NSObject {
  
    static let instance : LHCheckVersion = LHCheckVersion()

   class  func shareCheckVersion() -> LHCheckVersion {
        return instance
    }
    
    func isUpdataApp(appID : String) {
        //获取appstore上的最新版本号
        let appUrl = URL.init(string: "http://itunes.apple.com/lookup?id=" + appID)
        let appMsg = try? String.init(contentsOf: appUrl!, encoding: .utf8)
        guard (appMsg != nil) else { return }
        let appMsgDict:NSDictionary = getDictFromString(jString: appMsg!)
        let appResultsArray:NSArray = appMsgDict["results"] as! NSArray
        let appResultsDict:NSDictionary = appResultsArray.lastObject as! NSDictionary
        let appStoreVersion:String = appResultsDict["version"] as! String
        //获取当前手机安装使用的版本号
        let localVersion:String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        self.compareVersion(localVersion: localVersion, storeVersion: appStoreVersion,appID: appID)

    }
    
    //去更新
    private func updateApp(appId:String) {
        let updateUrl:URL = URL.init(string: "http://itunes.apple.com/app/id" + appId)!
        UIApplication.shared.open(updateUrl, options: [:], completionHandler: nil)
    }
    
    //不再提示
    private func noAlertAgain() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "NO_ALERt_AGAIN")
        userDefaults.synchronize()
    }
    
    //JSONString转字典
    private func getDictFromString(jString:String) -> NSDictionary {
        let jsonData:Data = jString.data(using: .utf8)!
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
    }

    private func compareVersion(localVersion: String, storeVersion: String, appID: String) {
        //用户是否设置不再提示
        let userDefaults = UserDefaults.standard
        let res = userDefaults.bool(forKey: "NO_ALERt_AGAIN")
        guard localVersion.compare(storeVersion) == ComparisonResult.orderedDescending,!res else {
            return
        }
        //appstore上的版本号大于本地版本号 - 说明有更新
        let alertC = UIAlertController.init(title: "版本更新了", message: "是否前往更新", preferredStyle: .alert)
        let yesAction = UIAlertAction.init(title: "去更新", style: .default, handler: { (handler) in
            self.updateApp(appId: appID)
        })
        let noAction = UIAlertAction.init(title: "下次再说", style: .cancel, handler: nil)
        let cancelAction = UIAlertAction.init(title: "不再提示", style: .default, handler: { (handler) in
            self.noAlertAgain()
        })
        alertC.addAction(yesAction)
        alertC.addAction(noAction)
        alertC.addAction(cancelAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertC, animated: true, completion: nil)
    }

}
