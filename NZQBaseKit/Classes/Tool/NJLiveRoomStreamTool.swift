//
//  DYLiveStreamTool.swift
//  DYLiveRoom
//
//  Created by NJHu on 2018/7/15.
//

import UIKit
import WebKit

public enum NJLiveRoomStreamToolError: Error {
    case timeout
    case pageFail
}

public class NJLiveRoomStreamTool: NSObject {
    public static var sharedTool: NJLiveRoomStreamTool = NJLiveRoomStreamTool()
    private var handles = [WKWebView: [String: Any]]()
}

extension NJLiveRoomStreamTool {
    
    /// 通过 h5Room链接 获取直播流地址, elementId和elementClass 只用填一个
    ///
    /// - Parameters:
    ///   - roomH5Url: 直播h5网页链接
    ///   - elementId: 直播h5网页 里边<video>标签的 id
    ///   - elementClass: 直播h5网页 里边<video>标签的class
    ///   - success: 成功的回调
    ///   - failure: 失败的回调
    public func nj_getStreamUrl(roomH5Url: String, elementId: String? = nil, elementClass: String? = nil, success: @escaping (_ roomH5Url: String, _ streamUrl: String) -> (), failure: @escaping (_ roomH5Url: String, _ error: Error) -> ()) {
        
        let webView = addWkWebView()
        setUpWkWebView(webView: webView)

        handles[webView] = ["success": success, "failure": failure, "roomH5Url": roomH5Url, "elementId": elementId, "elementClass": elementClass]
        
        if let url = URL(string: roomH5Url) {
            let urlRequestM = NSMutableURLRequest(url: url)
            webView.load(urlRequestM.copy() as! URLRequest)
        }else {
            self.failCallback(webView: webView, error: NJLiveRoomStreamToolError.pageFail)
        }
        
        let tinyDelay = DispatchTime.now() + Double(Int64(30 * Float(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: tinyDelay) {
            self.failCallback(webView: webView, error: NJLiveRoomStreamToolError.timeout)
        }
    }
}

// MARK:- handle
extension NJLiveRoomStreamTool {
    private func failCallback(webView: WKWebView, error: Error) {
        if let fail =  self.handles[webView]?["failure"] as? ((_ roomH5Url: String, _ error: Error) -> ()) {
            fail(self.handles[webView]?["roomH5Url"] as! String, error)
            webView.stopLoading()
            self.handles.removeValue(forKey: webView)
        }
    }
    private func successCallback(webView: WKWebView, streamUrl: String) {
        if let success =  self.handles[webView]?["success"] as? ((_ roomH5Url: String, _ streamUrl: String) -> ()) {
            success(self.handles[webView]?["roomH5Url"] as! String, streamUrl)
            webView.stopLoading()
            self.handles.removeValue(forKey: webView)
        }
    }
    // 通过js获得src
    private func evaluateVideoElementJS(webView: WKWebView) {
        if let elementId = self.handles[webView]?["elementId"] as? String {
            webView.evaluateJavaScript("document.querySelector(\"#\(elementId)\").src") { (streamUrl, error) in
                if let stream = streamUrl as? String, stream.lengthOfBytes(using: String.Encoding.utf8) > 0 {
                    self.successCallback(webView: webView, streamUrl: stream)
                }
            }
        }
        
        if let elementClass = self.handles[webView]?["elementClass"] as? String {
            webView.evaluateJavaScript("document.querySelector(\".\(elementClass)\").src") { (streamUrl, error) in
                if let stream = streamUrl as? String, stream.lengthOfBytes(using: String.Encoding.utf8) > 0 {
                    self.successCallback(webView: webView, streamUrl: stream)
                }
            }
        }
        
        webView.evaluateJavaScript("document.querySelector(\"video[src]\").src") { (streamUrl, error) in
            if let stream = streamUrl as? String, stream.lengthOfBytes(using: String.Encoding.utf8) > 0 {
                self.successCallback(webView: webView, streamUrl: stream)
            }
        }
    }
}

// MARK:- setting
extension NJLiveRoomStreamTool {
    private func addWkWebView() -> WKWebView {
        let configuration = WKWebViewConfiguration()
        let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 5, height: 5), configuration: configuration)
        return webView
    }
    private func setUpWkWebView(webView: WKWebView?) -> Void {
        let preferences = WKPreferences()
        
        //The minimum font size in points default is 0;
        preferences.minimumFontSize = 0;
        //是否支持JavaScript
        preferences.javaScriptEnabled = true;
        //不通过用户交互，是否可以打开窗口
        preferences.javaScriptCanOpenWindowsAutomatically = true;
        webView?.configuration.preferences = preferences
        
        webView?.configuration.userContentController = WKUserContentController()
        
        // 检测各种特殊的字符串：比如电话、网站
        webView?.configuration.dataDetectorTypes = .all
        // 播放视频
        webView?.configuration.allowsInlineMediaPlayback = true;
        
        webView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        webView?.isOpaque = false
        
        webView?.backgroundColor = UIColor.clear
        
        webView?.allowsBackForwardNavigationGestures = true
        
        webView?.allowsLinkPreview = true
        
        webView?.uiDelegate = self;
        
        webView?.navigationDelegate = self;
        
        if #available(iOS 11, *) {
            webView?.scrollView.contentInsetAdjustmentBehavior = .never
        }
    }
}


// MARK:- WKNavigationDelegate-导航监听
extension NJLiveRoomStreamTool: WKNavigationDelegate {
    // 1, 在发送请求之前，决定是否跳转
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        decisionHandler(WKNavigationActionPolicy.allow)
    }
    // 3, 6, 加载 HTTPS 的链接，需要权限认证时调用  \  如果 HTTPS 是用的证书在信任列表中这不要此代理方法
    public func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        if let trust = challenge.protectionSpace.serverTrust {
            let credential = URLCredential(trust: trust)
            completionHandler(.useCredential, credential)
        }else {
            completionHandler(.performDefaultHandling, nil)
        }
        self.evaluateVideoElementJS(webView: webView)
    }
    // 4, 在收到响应后，决定是否跳转, 在收到响应后，决定是否跳转和发送请求之前那个允许配套使用
    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Swift.Void) {
        decisionHandler(WKNavigationResponsePolicy.allow)
    }
    // 1-2, 接收到服务器跳转请求之后调用
    public func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
    }
    // 8, WKNavigation导航错误
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
    //当 WKWebView 总体内存占用过大，页面即将白屏的时候，系统会调用回调函数
    public func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        webView.reload()
        self.failCallback(webView: webView, error: NJLiveRoomStreamToolError.pageFail)
    }
}
// MARK:- WKNavigationDelegate-网页监听
extension NJLiveRoomStreamTool {
    // 2, 页面开始加载时调用
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    // 5,内容开始返回时调用
    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    // 7页面加载完成之后调用
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    // 9页面加载失败时调用
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.failCallback(webView: webView, error: NJLiveRoomStreamToolError.pageFail)
    }
}

// MARK:- WKUIDelegate
extension NJLiveRoomStreamTool: WKUIDelegate {
    
}



