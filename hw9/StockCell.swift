//
//  StockCell.swift
//  hw9
//
//  Created by Rui Luo on 11/28/17.
//  Copyright © 2017 Rui Luo. All rights reserved.
//

import UIKit

class StockCell: UITableViewCell {

    @IBOutlet weak var cellName: UILabel!
    
    @IBOutlet weak var cellPrice: UILabel!
    
    
    @IBOutlet weak var cellChange: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
