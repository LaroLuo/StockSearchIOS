//
//  HistoryViewController.swift
//  hw9
//
//  Created by Rui Luo on 11/26/17.
//  Copyright © 2017 Rui Luo. All rights reserved.
//

import UIKit
import WebKit





class HistoryViewController: UIViewController,WKUIDelegate,WKNavigationDelegate {
//    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//        <#code#>WKScriptMessageHandler
//    }
    
    var stringPassed = ""
    
    var webView:WKWebView!
    
    let userContentController = WKUserContentController()
    
    
    
    func initViews() {
        
//        self.webView = WKWebView(frame: CGRect(x:0,y:0,width:375,height:548))
//        webView = WKWebView(frame: self.view.frame, configuration: webConfig)
//        webView!.translatesAutoresizingMaskIntoConstraints = false
        self.webView = WKWebView(frame: .zero)
        view.addSubview(self.webView)
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        let height = NSLayoutConstraint(item: webView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: webView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: webView, attribute: .leftMargin, relatedBy: .equal, toItem: view, attribute: .leftMargin, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: webView, attribute: .rightMargin, relatedBy: .equal, toItem: view, attribute: .rightMargin, multiplier: 1, constant: 0)
        let bottomContraint = NSLayoutConstraint(item: webView, attribute: .bottomMargin, relatedBy: .equal, toItem: view, attribute: .bottomMargin, multiplier: 1, constant: 0)
        view.addConstraints([height, width, leftConstraint, rightConstraint, bottomContraint])

        
        
        view.addSubview(self.webView)
        //        self.webView.loadHTMLString("<h1>Title</h1><p>sfsdfd</p>", baseURL: nil)
//        let url:URL = Bundle.main.url(forResource: "historyPage", withExtension: "html")!
//        let req:URLRequest = URLRequest(url:url)
//        self.webView.uiDelegate = self
//        self.webView.navigationDelegate = self
        let htmlPath = Bundle.main.path(forResource : "test", ofType : "html")
        let folderPath = Bundle.main.bundlePath
        
        
        
        let baseUrl = URL(fileURLWithPath : folderPath, isDirectory : true)
        do {
            var htmlString = try NSString(contentsOfFile : htmlPath!, encoding: String.Encoding.utf8.rawValue)
            print(htmlString)
            self.webView.loadHTMLString(htmlString as String, baseURL: baseUrl)
            
        } catch {
                
            }
        self.webView.navigationDelegate = self

        self.view = self.webView
        
        
        

//        webView.load(req)
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        self.view.addSubview(activityIndicator)
        activityIndicator.center = self.view.center
        activityIndicator.startAnimating()
        var stt : String = "render_indicator('\(self.stringPassed)')"
        print (stt);
        
        self.webView.evaluateJavaScript(stt, completionHandler: nil)
        activityIndicator.stopAnimating()
        self.view = self.webView
    }
    
    override func loadView() {
        super.loadView()
        
        let config = WKWebViewConfiguration()
        config.userContentController = userContentController
        initViews()
//        userContentController.add(self as! WKScriptMessageHandler, name: "stockName")
    }
//    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
//        let stockName = self.stringPassed
//
//        // now use the name and token as you see fit!
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        webView.translatesAutoresizingMaskIntoConstraints = false
//        let width = NSLayoutConstraint(item : webView, attribute : .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier : 1.0, constant : 0)
//        let height = NSLayoutConstraint(item : webView, attribute : .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier : 1.0, constant : -300)
//        let top = NSLayoutConstraint(item : webView, attribute : .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier : 1.0, constant : 300)
//        view.addConstraints([width,height])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
