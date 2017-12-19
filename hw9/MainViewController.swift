//
//  ViewController.swift
//  hw9
//
//  Created by Rui Luo on 11/25/17.
//  Copyright © 2017 Rui Luo. All rights reserved.
//

import UIKit
import SearchTextField
import Alamofire
import AlamofireSwiftyJSON
import EasyToast
import SwiftSpinner
import SwiftyJSON

protocol DataToDetail {
    func getName(name : String)
}
//userDefault-




class MainViewController: UIViewController {
    
    //MARK: Properties
    let defaults  = UserDefaults.standard
    @IBOutlet weak var containerView: UIView!
    weak var currentController: FavoViewController?
    var newsFeeds : [News] = []
    @IBOutlet weak var getQuote: UIButton!
    var delegate : DataToDetail?
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBAction func onclickClear(_ sender: Any) {
        self.nameTextField.text = ""
    }
    func showActivityIndicatory(uiView: UIView) {
        var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 100, height: 100));
        actInd.center = uiView.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        uiView.addSubview(actInd)
        activityIndicator.startAnimating()
    }
    
    @IBAction func Quote(_ sender: UIButton) {
        view.endEditing(true)
        let myVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        delegate?.getName(name : nameTextField.text!)
        
        let trimmedString = nameTextField.text!.trimmingCharacters(in: .whitespaces)
        if trimmedString == ""{
            self.view.showToast("Enter a stock name or symbol", position: .bottom, popTime: 5, dismissOnTap: false)
        }else{
            myVC.stringPassed = trimmedString
            makeRequest(trimmedString: trimmedString, myVC : myVC)
            
        }

    }
    
    // get news and collect data from them
//    func didGetNews(json : Any){
//        var newsArr = [News]()
//        var obb = json["data"]["rss"]["channel"][0]["item"] as? [Any]
//        print (obb)
//    }
//
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNews"{
            let newsSegue = segue.destination as! NewsViewController
            newsSegue.newsFeeds = self.newsFeeds
        }
    }
    func customActivityIndicatory(_ viewContainer: UIView, startAnimate:Bool? = true) -> UIActivityIndicatorView {
        let mainContainer: UIView = UIView(frame: viewContainer.frame)
        mainContainer.center = viewContainer.center
        mainContainer.alpha = 0.5
        mainContainer.tag = 789456123
        mainContainer.isUserInteractionEnabled = false
        
        let viewBackgroundLoading: UIView = UIView(frame: CGRect(x:0,y: 0,width: 80,height: 80))
        viewBackgroundLoading.center = viewContainer.center
        viewBackgroundLoading.alpha = 0.5
        viewBackgroundLoading.clipsToBounds = true
        viewBackgroundLoading.layer.cornerRadius = 15
        
        let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.frame = CGRect(x:0.0,y: 0.0,width: 40.0, height: 40.0)
        activityIndicatorView.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        activityIndicatorView.center = CGPoint(x: viewBackgroundLoading.frame.size.width / 2, y: viewBackgroundLoading.frame.size.height / 2)
        if startAnimate!{
            viewBackgroundLoading.addSubview(activityIndicatorView)
            mainContainer.addSubview(viewBackgroundLoading)
            viewContainer.addSubview(mainContainer)
            activityIndicatorView.startAnimating()
        }else{
            for subview in viewContainer.subviews{
                if subview.tag == 789456123{
                    subview.removeFromSuperview()
                }
            }
        }
        return activityIndicatorView
    }

    
    func makeRequest(trimmedString : String, myVC : DetailViewController)
    {
        defaults.set(2, forKey: "req")
        let url_ind = "http://hw8-envv.us-west-1.elasticbeanstalk.com/api?func=iosDetail&name=\(trimmedString)"
        let url_news = "http://hw8-envv.us-west-1.elasticbeanstalk.com/api?func=iosNews&name=\(trimmedString)"
        SwiftSpinner.show("Loading data")
        Alamofire.request(url_ind).responseSwiftyJSON(completionHandler: {
            response in
            let json = response.result.value
            let isSuccess = response.result.isSuccess
            if (isSuccess && (json != nil))
            {
                print("ind back")
                var stockDetailtoDetail : [Dictionary<String,String>] = []
                var tmp : Dictionary<String,String> = ["left":"Stock Ticker Symbol" ,"right": json!["Stock Ticker Symbol"].stringValue]
                stockDetailtoDetail.append(tmp)
                tmp = ["left":"Change (Change Percent)" ,"right" : json!["Change (Change Percent)"].stringValue]
                stockDetailtoDetail.append(tmp)
                tmp = ["left":"Timestamp" ,"right": json!["Timestamp"].stringValue]
                stockDetailtoDetail.append(tmp)
                tmp = ["left":"Open" ,"right": json!["Open"].stringValue]
                stockDetailtoDetail.append(tmp)
                tmp = ["left":"Previous Close" ,"right": json!["Previous Close"].stringValue]
                stockDetailtoDetail.append(tmp)
                tmp = ["left":"Daily Range" ,"right": json!["Daily Range"].stringValue]
                stockDetailtoDetail.append(tmp)
                tmp = ["left":"Volume" ,"right": json!["Volume"].stringValue]
                stockDetailtoDetail.append(tmp)
                tmp = ["left":"change_price" ,"right": json!["change_price"].stringValue]
                stockDetailtoDetail.append(tmp)
                
                myVC.curDetail = stockDetailtoDetail
                self.defaults.set(self.defaults.integer(forKey: "req") - 1, forKey:"req")
                if self.defaults.integer(forKey: "req") == 0{
                    SwiftSpinner.hide()
                    self.navigationController?.pushViewController(myVC, animated: true)
                }
            }
        })
        
        Alamofire.request(url_news).responseSwiftyJSON(completionHandler: {
            response in
            let json = response.result.value
            let isSuccess = response.result.isSuccess
            if (isSuccess && (json != nil))
            {
                print("News back")
                for index in 0...4{
                    var newsItem = News(title: json![index]["title"].string!, author: json![index]["author"].string!, pubDate : json![index]["pubDate"].string!, link : json![index]["link"].string! )
                    self.newsFeeds.append(newsItem)
                }
                print(self.newsFeeds)
                myVC.newsFeeds = self.newsFeeds

//                let encodedData = NSKeyedArchiver.archivedData(withRootObject: newsFeeds)
//                self.defaults.set(encodedData,forKey:"newsJSON")
                self.defaults.set(self.defaults.integer(forKey: "req") - 1, forKey:"req")
                if self.defaults.integer(forKey: "req") == 0{
                    SwiftSpinner.hide()
                    self.navigationController?.pushViewController(myVC, animated: true)
                }
            }
        })
    }
    
    
    @IBOutlet weak var nameTextField: SearchTextField!

    fileprivate func configureSearch() {
        // Set theme - Default: light
        nameTextField.theme = SearchTextFieldTheme.lightTheme()
        
        // Define a header - Default: nothing
        let header = UILabel(frame: CGRect(x: 0, y: 0, width: nameTextField.frame.width, height: 30))
//        nameTextField = UIColor.lightGray.withAlphaComponent(0.3)
        header.textAlignment = .center
        header.font = UIFont.systemFont(ofSize: 14)
        header.text = "Pick your option"
        nameTextField.resultsListHeader = header
        
        
        // Modify current theme properties
        nameTextField.theme.font = UIFont.systemFont(ofSize: 12)
        nameTextField.theme.bgColor = UIColor.lightGray.withAlphaComponent(0.2)
        nameTextField.theme.borderColor = UIColor.lightGray.withAlphaComponent(0.5)
        nameTextField.theme.separatorColor = UIColor.lightGray.withAlphaComponent(0.5)
        nameTextField.theme.cellHeight = 50
        nameTextField.theme.placeholderColor = UIColor.lightGray
        
        // Max number of results - Default: No limit
        nameTextField.maxNumberOfResults = 5
        
        // Max results list height - Default: No limit
        nameTextField.maxResultsListHeight = 200
        
        // Set specific comparision options - Default: .caseInsensitive
        nameTextField.comparisonOptions = [.caseInsensitive]
        
        // You can force the results list to support RTL languages - Default: false
        nameTextField.forceRightToLeft = false
        
        // Customize highlight attributes - Default: Bold
//        nameTextField.highlightAttributes = [NSAttributedStringKey.backgroundColor: UIColor.yellow, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 12)]
        
        // Handle item selection - Default behaviour: item title set to the text field
        nameTextField.itemSelectionHandler = { filteredResults, itemPosition in
            // Just in case you need the item position
            let item = filteredResults[itemPosition]
            print("Item at position \(itemPosition): \(item.title)")
            
            // Do whatever you want with the picked item
            self.nameTextField.text = item.title
        }
        
        // Max number of results - Default: No limit
        nameTextField.maxNumberOfResults = 8
        // Set specific comparision options - Default: .caseInsensitive
        nameTextField.comparisonOptions = [.caseInsensitive]
        
        nameTextField.itemSelectionHandler = { filteredResults, itemPosition in
            // Just in case you need the item position
            let item = filteredResults[itemPosition]
            print("Item at position \(itemPosition): \(item.title)")
            
            // Do whatever you want with the picked item
            self.nameTextField.text = item.title
        }
        
        // Update data source when the user stops typing
        nameTextField.userStoppedTypingHandler = {
            if let criteria = self.nameTextField.text {
                    // Show loading indicator
                    self.nameTextField.showLoadingIndicator()
                    
                    self.filterAcronymInBackground(criteria) { results in
                        // Set new items to filter
                        self.nameTextField.filterItems(results)
                        
                        // Stop loading indicator
                        self.nameTextField.stopLoadingIndicator()
                }
            }
            } as (() -> Void)
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    func addSubview(subView:UIView, toView parentView:UIView) {
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|",
                                                                 options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|",
                                                                 options: [], metrics: nil, views: viewBindingsDict))
    }
    override func viewDidLoad() {
        print("Main View Load")
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor (red: 1.0, green: 1.0, blue: 0.5, alpha: 1.0)

        let sList : [String] = ["AAPL", "MSFT"]
        defaults.set(sList, forKey: "originList")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let otherVC = storyBoard.instantiateViewController(withIdentifier: "FavoViewController") as! FavoViewController
        otherVC.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(otherVC)
        self.addSubview(subView: otherVC.view, toView: self.containerView)
        self.currentController = otherVC

        self.navigationItem.title = "Stock Market Search"

        configureSearch()
        refFavoList()

    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    fileprivate func filterAcronymInBackground(_ criteria: String, callback: @escaping ((_ results: [SearchTextFieldItem]) -> Void)) {
        let url = URL(string: "http://hw8-envv.us-west-1.elasticbeanstalk.com/api?func=autocomplete&name=\(criteria)")
        
        if let url = url {
            let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
                do {
                    if let data = data {
                        let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [[String:AnyObject]]
                            NSLog("%@", jsonData);
                        
                            var results = [SearchTextFieldItem]()
                            
                            for result in jsonData {
                                let str1 = result["Name"] as! String
                                let str2 = result["Exchange"] as! String
                                let str = str1 + "-" + str2
                                results.append(SearchTextFieldItem(title: result["Symbol"] as! String, subtitle: str))
                            }
                            
                            DispatchQueue.main.async {
                                callback(results)
                            }
                        
                    } else {
                        DispatchQueue.main.async {
                            callback([])
                        }
                    }
                }
                catch {
                    print("Network error: \(error)")
                    DispatchQueue.main.async {
                        callback([])
                    }
                }
            })
            
            task.resume()
        }
    }
    //refresh favorite list by using defaults.originList
    //
    func refFavoList(){
//        showActivityIndicatory(uiView: <#UIView#>)
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        self.view.addSubview(activityIndicator)
        activityIndicator.center = self.view.center
        activityIndicator.startAnimating()
        self.customActivityIndicatory(self.view)
        var apiurl : String = "hw8-envv.us-west-1.elasticbeanstalk.com/api?func=iosRefresh&name="
        let strArr : [String] = defaults.stringArray(forKey: "originList")!
        if strArr.count != 0{
            for name : String in strArr{
                apiurl = apiurl + name + "-"
            }
            
            let indexEndOfText = apiurl.index(apiurl.endIndex, offsetBy: -1)
            let substr = apiurl[..<indexEndOfText]
            
            apiurl = String(substr)
            print(apiurl)
            Alamofire.request(apiurl).responseSwiftyJSON(completionHandler: {
                response in
                let json = response.result.value
                let isSuccess = response.result.isSuccess
                if (isSuccess && (json != nil))
                {
                    print("json  ",json)
                    var favoItems : [FavoItem]  = []
                    var x : Int = 0
                    for (index,subJson):(String, JSON) in json! {
                        // Do something you want
                        if subJson != nil {
                            let favoItem = FavoItem(price: subJson["price"].string!, symbol: subJson["symbol"].string!,volume : subJson["volume"].string!, change_percent : subJson["change_percent"].string!, change_price : subJson["change_price"].string!, text: subJson["text"].string!)
                            favoItems.append(favoItem)
                        }
                    }
//                    for x in 0 ..< arr!.count {
//!                        let favoItem = FavoItem(price: arr![x]["price"]!, symbol: arr![x]["symbol"]!,volume : arr[x]!["volume"]!, change_percent : arr![x]["change_percent"]!, change_price : arr![x]["change_price"]!, text:arr![x]["text"]!)
//                    }
                    print("main favo Items ", favoItems)
                    self.currentController?.favoItems = favoItems
                    self.customActivityIndicatory(self.view, startAnimate: false)
                    activityIndicator.stopAnimating()
                    self.currentController?.stockTableView.reloadData()
                }
            })
            
        }
    }
    

}

