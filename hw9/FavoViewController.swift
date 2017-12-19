//
//  FavoViewController.swift
//  hw9
//
//  Created by Rui Luo on 11/28/17.
//  Copyright © 2017 Rui Luo. All rights reserved.
//

import UIKit
import SearchTextField
import Alamofire
import AlamofireSwiftyJSON
import EasyToast
import SwiftSpinner
import SwiftyJSON


class FavoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    
    var newsFeeds : [News]  = []
    @IBAction func againToRefresh(_ sender: Any) {
        favoItems = []
        stockTableView.reloadData()
        refFavoList()
    }
    
    let defaults = UserDefaults.standard
    var timer: Timer!
    @IBOutlet weak var refButt: UISwitch!
    
    @IBAction func autoRef(_ sender: Any) {
        if refButt.isOn{
            timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector:#selector(FavoViewController.refFavoList), userInfo: nil, repeats: true)
        }else{
            timer.invalidate()
        }
        
        
    }
    @IBOutlet weak var didRefresh: UIButton!
    
    @IBOutlet weak var stockTableView: UITableView!

    var favoItems : [FavoItem] = []
    
    var deletePlanetIndexPath: NSIndexPath? = nil

    func refFavoList(){
        favoItems = []
        stockTableView.reloadData()
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        self.view.addSubview(activityIndicator)
        activityIndicator.center = self.view.center
        activityIndicator.startAnimating()
        var apiurl : String = "http://hw8-envv.us-west-1.elasticbeanstalk.com/api?func=iosRefresh&name="
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
                        }else{
                            self.view.showToast("Network error, favorite list data lost", position: .bottom, popTime: 2, dismissOnTap: false)
                        }
                    }
                    //                    for x in 0 ..< arr!.count {
                    //!                        let favoItem = FavoItem(price: arr![x]["price"]!, symbol: arr![x]["symbol"]!,volume : arr[x]!["volume"]!, change_percent : arr![x]["change_percent"]!, change_price : arr![x]["change_price"]!, text:arr![x]["text"]!)
                    //                    }
                    print("main favo Items ", favoItems)
                    activityIndicator.stopAnimating()
                    self.favoItems = favoItems
                    self.stockTableView.reloadData()
                }
            })
            
        }
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        self.reaList = defaults.dictionary(forKey: "originList") as! [Dictionary<String, String>]
//        print(self.reaList.count)
        return self.favoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("good")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellStock", for: indexPath) as! StockCell
        
        cell.cellName.text = self.favoItems[indexPath.row].symbol
        cell.cellPrice.text = self.favoItems[indexPath.row].price
        cell.cellChange.text = self.favoItems[indexPath.row].text
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let myVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        let name = favoItems[indexPath.row].symbol
        myVC.stringPassed = name
        makeRequest(trimmedString: name, myVC : myVC)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.deletePlanetIndexPath = indexPath as NSIndexPath
            if let indexPath = deletePlanetIndexPath {
                tableView.beginUpdates()
                let name = favoItems[indexPath.row].symbol
                var strArr : [String] = defaults.stringArray(forKey: "originList")!
                strArr.remove(at: strArr.index(of: name)!)
                defaults.set(strArr, forKey: "originList")
                self.favoItems.remove(at:indexPath.row)
                // Note that indexPath is wrapped in an array:  [indexPath]
                tableView.deleteRows(at: [indexPath as IndexPath], with: .automatic)
                
                deletePlanetIndexPath = nil
                
                tableView.endUpdates()
            }
        }else {

        }
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
    
    

    
    
    
    
    override func viewDidLoad() {
        refButt.isOn = false;
        super.viewDidLoad()
        didRefresh.setImage(UIImage(named: "refresh"), for: .normal)
        print("favoitems  ",self.favoItems)
        self.stockTableView.reloadData()
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
