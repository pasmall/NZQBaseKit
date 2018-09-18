//
//  NJNetworkTool.swift
//  NJDouYu
//
//  Created by HuXuPeng on 2018/5/19.
//  Copyright © 2018年 njhu. All rights reserved.
//

import UIKit

// MARK:- NJResponse
public class NJResponse: NSObject {
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
        return "\n请求: \(requestUrl), \n状态吗: \(statusCode), \n错误: \(error), \n错误Msg: \(errorMsg), \n响应头: \(headers), \n响应体: \(responseObject)"
    }
}


// MARK:- NJNetworkTool
import Alamofire

public enum NJNetworkToolError: Error {
    case networkNotReachable
    case urlWrong
    case serverWrong
}

public class NJNetworkTool: NSObject {
    public static var sharedTool: NJNetworkTool = NJNetworkTool()
    public let reachabilityManager = NetworkReachabilityManager()
    public var responseFormat: (_ response: NJResponse) -> NJResponse = { (_ response: NJResponse) -> NJResponse in
        return response
    }
    public override init() {
        super.init()
        reachabilityManager?.startListening()
    }
}

extension NJNetworkTool {
    
    public func GET(_ url: String, parameters: [String: Any]?, completionHandler: @escaping (_ response: NJResponse) -> Void) {
        self.request(url, method: HTTPMethod.get, parameters: parameters, completionHandler: completionHandler)
    }
    public func POST(_ url: String, parameters: [String: Any]?, completionHandler: @escaping (_ response: NJResponse) -> Void) {
        self.request(url, method: HTTPMethod.post, parameters: parameters, completionHandler: completionHandler)
    }
}

// MARK:- 请求
extension NJNetworkTool {
    
    private func request(_ url: String, method: HTTPMethod = .get, parameters: [String: Any]?, completionHandler: @escaping (_ response: NJResponse) -> Void) {
        // 网络不可链接
        if reachabilityManager != nil &&  reachabilityManager!.networkReachabilityStatus == .notReachable{
            let result =  Result<Any>.failure(NJNetworkToolError.networkNotReachable)
            self.wrapper(dataResponse: DataResponse(request: nil, response: nil, data: nil, result: result), completionHandler: completionHandler)
            return
        }
        
        guard let urlStr = url.urlEncoding() else {
            let result =  Result<Any>.failure(NJNetworkToolError.urlWrong)
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
extension NJNetworkTool {
    private func wrapper(dataResponse: DataResponse<Any>, completionHandler: @escaping (_ response: NJResponse) -> Void) {
        
        let response = NJResponse()
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
extension NJNetworkTool {
    
    public func upload(_ url: String, parameters: [String : Any]?, formDataHandler: @escaping (_ formData: MultipartFormData) -> [Data: String]?, completionHandler: @escaping (_ response: NJResponse) -> Void) {
        
        Alamofire.upload(multipartFormData: { (formData) in
            let datas = formDataHandler(formData)
            if let datas = datas {
                let mineType = "application/octet-stream";
                for (index, pair) in datas.enumerated() {
                    formData.append(pair.key, withName: pair.value, fileName: "random", mimeType: mineType)
                }
            }
            
        }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: url, method: HTTPMethod.post, headers: nil) { (result) in
//            self.wrapper(dataResponse: result, completionHandler: completionHandler)
        }
    }
}









