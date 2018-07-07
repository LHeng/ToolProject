//
//  LHBaseHttps.swift
//  LHTool
//
//  Created by 刘恒 on 2018/6/28.
//  Copyright © 2018年 LH. All rights reserved.
//

import UIKit
import Alamofire

enum RequestMethod {
    
    case RequestMethodGET
    case RequestMethodPOST
    
}
class LHBaseHttps: NSObject {

    var baseUrl:String = "https://sapi.o2o-test.mao-wo.com/o2o-store-api/"    //baseUrl
    var isNeedAccessToken:Bool = true  //是否拼接AccessToken
    var baseParams:NSMutableDictionary = [:]  //公共参数
    
    static let shareLHBaseHttps = LHBaseHttps()
    private override init() {
        
    }
    
    //MARK:拼接完整的url
    func getcCompleteUrl(url:String) -> String {
        let newUrl = self.baseUrl.appending(url)
        if self.isNeedAccessToken {
            //拼接AccessToken
        }
        return newUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    }
    
    //MARK:拼接完整的参数
    func CombinationParams(params:NSDictionary) -> NSDictionary {
        
        self.baseParams.addEntries(from:params as! [AnyHashable : Any])
        return self.baseParams
    }
    
    //MARK:获取请求方式
    func getHttpMethod(method:RequestMethod) -> HTTPMethod {
        if method == .RequestMethodPOST {
            return .post
        } else {
            return .get
        }
    }
    
    //MARK:上传数据：post or get
    func RequestParams(url:String,method:RequestMethod,params:NSMutableDictionary,success:@escaping (AnyObject)->(),failure:@escaping (Error)->()) -> Void {
        
        let allParams = self.CombinationParams(params: params)
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            //            "Accept": "text/javascript",
            //            "Accept": "text/html",
            //            "Accept": "text/plain"
        ]
        
        print(self.getcCompleteUrl(url:url))
        print(allParams)
        
        //验证证书
        self .verificationCertificate()
        
        Alamofire.request(self.getcCompleteUrl(url:url) as String, method: self.getHttpMethod(method: method), parameters:allParams as? Parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(let value):
                
                let dic:NSDictionary = value as! NSDictionary
                let status:NSNumber = dic.object(forKey:"success") as! NSNumber
                if status.isEqual(to: NSNumber.init(value: 0)) {
                    
                    //返回错误码
                    success(dic.object(forKey: "code") as AnyObject)
                    
                } else {
                    
                    let resultData:NSString = dic.object(forKey: "result") as! NSString
                    
                    if resultData.length == 0 {
                        //123456代表没有数据（NSNumber）
                        success(NSNumber.init(value: 123456) as AnyObject)
                        
                    } else {
                        
                        //base64解码
                        let decodedData = NSData.init(base64Encoded: dic.object(forKey: "result") as! String, options: NSData.Base64DecodingOptions.init(rawValue: 0))
                        
                        let decodedString:NSString = NSString(data: decodedData! as Data, encoding: String.Encoding.utf8.rawValue)!
                        
                        //解析json字符串
                        let data:Data = decodedString.data(using: String.Encoding.utf8.rawValue)!
                        let resultDic = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                        success(resultDic as AnyObject)
                        
                    }
                }
                
                break
                
            case .failure(let error):
                failure(error)
                break
                
            }
            
        }
    }
    
    //MARK:上传带图片的数据
    //注意，图片必须为Data||NSData类型，其他参数尽量传String或者NSString
    func RequestImageParams(url:String,params:NSMutableDictionary,success:@escaping (AnyObject)->(),failure:@escaping (Error)->()) -> Void {
        
        //验证证书
        self .verificationCertificate()
        
        Alamofire.upload(multipartFormData: { (multipartFormData:MultipartFormData) in
            
            let allParams = self.CombinationParams(params: params)
            
            for (key, value)in allParams {
                
                if value is Data || value is NSData {
                    
                    let imageName = String(describing: NSDate()).appending(".png")
                    multipartFormData.append(value as! Data, withName: key as! String, fileName: imageName, mimeType: "image/png")
                    
                } else {
                    
                    let str:String = value as! String
                    multipartFormData.append(str.data(using: .utf8)!, withName: key as! String)
                    
                }
                
            }
            
            
            
        }, to: self.getcCompleteUrl(url: url) as String) { (encodingResult:SessionManager.MultipartFormDataEncodingResult) in
            
            switch encodingResult {
            case .success(let upload, _, _):
                
                upload.responseJSON(completionHandler: { (response:DataResponse<Any>) in
                    
                    switch(response.result) {
                    case .success(let value):
                        
                        let dic:NSDictionary = value as! NSDictionary
                        let status:NSNumber = dic.object(forKey:"success") as! NSNumber
                        if status.isEqual(to: NSNumber.init(value: 0)) {
                            
                            //返回错误码
                            success(dic.object(forKey: "code") as AnyObject)
                            
                        } else {
                            
                            let resultData:NSString = dic.object(forKey: "result") as! NSString
                            
                            if resultData.length == 0 {
                                //123456代表没有数据
                                success(NSNumber.init(value: 123456) as AnyObject)
                                
                            } else {
                                
                                //base64解码
                                let decodedData = NSData.init(base64Encoded: dic.object(forKey: "result") as! String, options: NSData.Base64DecodingOptions.init(rawValue: 0))
                                
                                let decodedString:NSString = NSString(data: decodedData! as Data, encoding: String.Encoding.utf8.rawValue)!
                                
                                //解析json字符串
                                let data:Data = decodedString.data(using: String.Encoding.utf8.rawValue)!
                                let resultDic = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                                
                                success(resultDic as AnyObject)
                                
                            }
                        }
                        
                        break
                        
                    case .failure(let error):
                        
                        failure(error)
                        break
                        
                    }
                })
                break
            case .failure(let error):
                
                failure(error)
                break
            }
            
        }
    }
    
    //MARK:https证书验证
    func verificationCertificate() -> Void {
        
        let manager = SessionManager.default
        
        manager.delegate.sessionDidReceiveChallenge = { session, challenge in
            
            var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
            var credential: URLCredential?
            
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                
                disposition = URLSession.AuthChallengeDisposition.useCredential
                credential = URLCredential.init(trust: challenge.protectionSpace.serverTrust!)
                
            } else {
                if challenge.previousFailureCount > 0 {
                    
                    disposition = .cancelAuthenticationChallenge
                    
                } else {
                    
                    credential = manager.session.configuration.urlCredentialStorage?.defaultCredential(for: challenge.protectionSpace)
                    
                    if credential != nil {
                        disposition = .useCredential
                    }
                }
            }
            
            return (disposition, credential)
        }
        
    }
    
}
