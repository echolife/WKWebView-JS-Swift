//
//  ViewController.swift
//  Browser
//
//  Created by 王滔 on 7/6/15.
//  Copyright (c) 2015 王滔. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler, WKUIDelegate{
    
    var webView: WKWebView!
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 注册js调用oc 方法
        let config = WKWebViewConfiguration()
        config.userContentController.addScriptMessageHandler(self, name: "printQR")
        
        // 将通过oc修改js背景
        let source = "document.body.style.background = \"#777\";"
        let script = WKUserScript(source: source, injectionTime: .AtDocumentStart, forMainFrameOnly: true)
        config.userContentController.addUserScript(script)
        
        webView = WKWebView(frame: CGRectZero, configuration: config)
        webView.navigationDelegate = self
        webView.UIDelegate = self
        view.addSubview(webView)

 
        webView.setTranslatesAutoresizingMaskIntoConstraints(false)
        let height = NSLayoutConstraint(item: webView, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: webView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0)
        view.addConstraints([height, width])
        

  
       var patch :String = NSBundle.mainBundle().pathForResource("ExampleApp.html", ofType: nil)!
        var url :NSURL = NSURL(fileURLWithPath: patch)!
//        let url = NSURL(string:"http://192.168.3.130/Home/Pad/index")
        let request = NSURLRequest(URL:url)
        var content: NSString = NSString(contentsOfFile: patch, encoding: NSUTF8StringEncoding, error: nil)!
        webView.loadHTMLString(content as String, baseURL: url)
        
    }

    //======
    // WKNavigationDelegate
    //======
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        println("开始加载")
    }
    
    // 加载完成
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        
        println("完成加载")
        
         // oc调用js
        var parmas = "Hello world"
        var exec_template = "getRelatedArticles('\(parmas)');"
       
        webView.evaluateJavaScript(exec_template, completionHandler: { (_, error) -> Void in
            println(error);

        })
        
        
       
 
    }
    
    // 有错误发生的时候调用
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    // 服务器redirect时调用
    func webView(webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
 
    
    // 当客户端收到服务器的响应头，根据response相关信息，可以决定这次跳转是否可以继续进行
    func webView(webView: WKWebView, decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse, decisionHandler: (WKNavigationResponsePolicy) -> Void) {

        decisionHandler(WKNavigationResponsePolicy.Allow)
    }
    
    
    // 决定是否让一个网页被加载的信息
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
//        if (navigationAction.navigationType == WKNavigationType.LinkActivated && !navigationAction.request.URL!.host!.lowercaseString.hasPrefix("www.appcoda.com")) {
//            UIApplication.sharedApplication().openURL(navigationAction.request.URL!)
//            decisionHandler(WKNavigationActionPolicy.Cancel)
//        } else {
            decisionHandler(WKNavigationActionPolicy.Allow)
//        }
    }
    
    //======
    // WKScriptMessageHandler
    //======
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
//        if message.name == "printQR" { }
        
        println(message.body)
    }
    
    
    //======
    // WKUIDelegate
    //======
    
    // 接口的作用是打开新窗口委托
    func webView(webView: WKWebView, createWebViewWithConfiguration configuration: WKWebViewConfiguration, forNavigationAction navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        return nil
    }
    
    // js 里面的alert实现，如果不实现，网页的alert函数无效
    func webView(webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: () -> Void) {
        let alert = UIAlertController(title: "alert", message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: { (action) -> Void in
            completionHandler()
        }))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func webView(webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: (Bool) -> Void) {
        
        let alert = UIAlertController(title: "alert", message: nil, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler:{ (action) -> Void in
            completionHandler(true)
            
            }))
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler:{ (action) -> Void in
            completionHandler(false)
            
        }))
        presentViewController(alert, animated: true, completion: nil)

    }
    
    func webView(webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: (String!) -> Void) {
        completionHandler("Client Not handler");
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

