//
//  DetailCell.swift
//  hw9
//
//  Created by Rui Luo on 11/30/17.
//  Copyright © 2017 Rui Luo. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {
    
    
    @IBOutlet weak var left: UILabel!
    @IBOutlet weak var right: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
