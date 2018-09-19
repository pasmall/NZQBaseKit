//
//  NZQNetworkTool.swift
//  NZQBaseKit
//
//  Created by Lyric on 2018/9/19.
//  Copyright © 2018年 Lyric. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

public class NZQResponse : NSObject {
    public var error: Error? {
        didSet {
            errorMsg = error?.localizedDescription
        }
    }
    public var requestUrl: URL?
    public var errorMsg: String?
    public var statusCode: Int = 0
    public var headers: [AnyHashable: Any]?
    public var responseObject: Any?
    public var timeline: Timeline?
    public override var description: String {
        return "\n请求: \(String(describing: requestUrl)), \n状态吗: \(String(describing: statusCode)), \n错误: \(String(describing: error)), \n错误Msg: \(String(describing: errorMsg)), \n响应头: \(String(describing: headers)), \n响应体: \(String(describing: responseObject))"
    }
}

public enum NZQNetworkToolError: Error {
    case networkNotReachable
    case urlWrong
    case serverWrong
}

public class NZQNetworkTool: NSObject {
    public static var sharedTool: NZQNetworkTool = NZQNetworkTool()
    public let reachabilityManager = NetworkReachabilityManager()
    public var responseFormat: (_ response: NZQResponse) -> NZQResponse = { (_ response: NZQResponse) -> NZQResponse in
        return response
    }
    public override init() {
        super.init()
        //打开网络监测
        reachabilityManager?.startListening()
    }
}

extension NZQNetworkTool {
    public func GET(_ url: String, parameters: [String: Any]?, completionHandler: @escaping (_ response: NZQResponse) -> Void) {
        self.request(url, method: HTTPMethod.get, parameters: parameters, completionHandler: completionHandler)
    }
    public func POST(_ url: String, parameters: [String: Any]?, completionHandler: @escaping (_ response: NZQResponse) -> Void) {
        self.request(url, method: HTTPMethod.post, parameters: parameters, completionHandler: completionHandler)
    }
}

public extension String {
    
    public func urlEncoding() -> String? {
        let characters = "`#%^{}\"[]|\\<> "
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.init(charactersIn: characters).inverted)
    }
}

// MARK:- 请求
extension NZQNetworkTool {
    
    private func request(_ url: String, method: HTTPMethod = .get, parameters: [String: Any]?, completionHandler: @escaping (_ response: NZQResponse) -> Void) {
        // 网络不可链接
        if reachabilityManager != nil &&  reachabilityManager!.networkReachabilityStatus == .notReachable{
            let result =  Result<Any>.failure(NZQNetworkToolError.networkNotReachable)
            self.wrapper(dataResponse: DataResponse(request: nil, response: nil, data: nil, result: result), completionHandler: completionHandler)
            return
        }
        
        guard url.urlEncoding() != nil else {
            let result =  Result<Any>.failure(NZQNetworkToolError.urlWrong)
            self.wrapper(dataResponse: DataResponse(request: nil, response: nil, data: nil, result: result), completionHandler: completionHandler)
            return;
        }
        
        Alamofire.request(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .responseJSON(queue: nil, options: JSONSerialization.ReadingOptions.mutableContainers) { (dataResponse) in
                self.wrapper(dataResponse: dataResponse, completionHandler: completionHandler)
        }
    }
}

// MARK:- 解析数据
extension NZQNetworkTool {
    private func wrapper(dataResponse: DataResponse<Any>, completionHandler: @escaping (_ response: NZQResponse) -> Void) {
        
        let response = NZQResponse()
        response.requestUrl = dataResponse.request?.url
        response.error = dataResponse.result.error
        response.errorMsg = dataResponse.result.error?.localizedDescription
        response.statusCode = dataResponse.response?.statusCode ?? 0
        response.headers = dataResponse.response?.allHeaderFields
        response.timeline = dataResponse.timeline
        response.responseObject = dataResponse.result.value ?? dataResponse.data
        // 打印
        print(response)
        let newResponse = self.responseFormat(response)
        
        DispatchQueue.main.async {
            completionHandler(newResponse)
        }
    }
}

// MARK:- 上传
extension NZQNetworkTool {
    
    public func upload(_ url: String, parameters: [String : Any]?, formDataHandler: @escaping (_ formData: MultipartFormData) -> [Data: String]?, completionHandler: @escaping (_ response: NZQResponse) -> Void) {
        
        Alamofire.upload(multipartFormData: { (formData) in
            let datas = formDataHandler(formData)
            if let datas = datas {
                let mineType = "application/octet-stream";
                for (_, pair) in datas.enumerated() {
                    formData.append(pair.key, withName: pair.value, fileName: "random", mimeType: mineType)
                }
            }
            
        }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: url, method: HTTPMethod.post, headers: nil) { (result) in
//            self.wrapper(dataResponse: result, completionHandler: completionHandler)
            return
        }
    }
}




