//
//  favoItem.swift
//  hw9
//
//  Created by Rui Luo on 11/29/17.
//  Copyright © 2017 Rui Luo. All rights reserved.
//

import Foundation

class FavoItem{
    var price : String
    var symbol : String
    var volume : String
    var change_percent : String
    var change_price : String
    var text : String
    init(price: String, symbol: String,volume : String, change_percent : String, change_price : String, text:String) {
        self.price  = price
        self.symbol = symbol
        self.volume = volume
        self.change_percent = change_percent
        self.change_price = change_price
        self.text = text

    }
}
