//
//  CurrentViewController.swift
//  hw9
//
//  Created by Rui Luo on 11/26/17.
//  Copyright © 2017 Rui Luo. All rights reserved.
//

import UIKit

class CurrentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var curDetail : [Dictionary<String, String>] = []
     @IBOutlet weak var detailTable: UITableView!
    

    
   
    
    var str = ""
    let defaults = UserDefaults.standard
    @IBOutlet weak var mark: UIButton!
    
    @IBAction func markTheStock(_ sender: Any) {
        let name = self.str
        var strArr : [String] = defaults.stringArray(forKey: "originList")!
        if strArr.contains(name){
            strArr.remove(at: strArr.index(of: name)!)
            mark.setImage(UIImage(named: "unmark"), for: .normal)
        }else{
            strArr.append(name)
            mark.setImage(UIImage(named: "mark"), for: .normal)
        }
        defaults.set(strArr, forKey: "originList")
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let name = self.str
        var strArr : [String] = defaults.stringArray(forKey: "originList")!
        if strArr.contains(name){
            mark.setImage(UIImage(named: "mark"), for: .normal)
        }else{
            mark.setImage(UIImage(named: "unmark"), for: .normal)
        }
        
        print("CurrentViewController load")

        // Do any additional setup after loading the view.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("curDetail " , curDetail)
        return self.curDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellDetail", for: indexPath) as! DetailCell
        if cell == nil {
            self.detailTable.register(DetailCell.self, forCellReuseIdentifier: "cellDetail")
            
            cell = DetailCell(style: UITableViewCellStyle.default, reuseIdentifier: "cellDetail")
        }
        print(curDetail[indexPath.row])
        if let val = self.curDetail[indexPath.row]["left"] {
            cell.left.text = val
        }else{
            cell.left.text = "left"
        }
        if let val2  = self.curDetail[indexPath.row]["right"] {
            cell.right.text = val2
        }else{
            cell.right.text = "right"
        }
    
        
        return cell
        
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
