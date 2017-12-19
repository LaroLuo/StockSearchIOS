//
//  NewsViewController.swift
//  hw9
//
//  Created by Rui Luo on 11/26/17.
//  Copyright © 2017 Rui Luo. All rights reserved.
//

import UIKit


class NewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let defaults = UserDefaults.standard
    var reaList : [News] = []
    var newsFeeds : [News] = []
    @IBOutlet weak var newsTable: UITableView!


    

    func numberOfSections(in tableView: UITableView) -> Int {
        print ("numberOfSection")
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.reaList.count)
        return self.reaList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellNews", for: indexPath) as! NewsCell
        
        cell.newsTitle.text = reaList[indexPath.row].newsTitle
        cell.newsAuthor.text = reaList[indexPath.row].newsAuthor
        cell.newsPubDate.text = reaList[indexPath.row].newsPubDate
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        print("select \(indexPath.row) row")
        let url = reaList[indexPath.row].newsLink
        UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
    }
    
    override func viewDidLoad() {
        print("NewsViewController load")
        self.reaList = self.newsFeeds
        print(self.reaList.count)
        super.viewDidLoad()


        // Do any additional setup after loading the view.
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
