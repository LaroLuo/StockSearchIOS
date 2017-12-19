//
//  stockDetail.swift
//  hw9
//
//  Created by Rui Luo on 11/30/17.
//  Copyright © 2017 Rui Luo. All rights reserved.
//

import Foundation
class stockDetail{
    var StockTickerSymbol : String
    var LastPrice : String
    var ChangePercent : String
    var Timestamp : String
    var Open : String
    var PreviousClose : String
    var DailyRange : String
    var Volume : String
    var change_price : String
    init(StockTickerSymbol: String, LastPrice: String,ChangePercent : String, Timestamp : String, Open : String, PreviousClose:String, DailyRange: String, Volume : String, change_price : String) {
        self.StockTickerSymbol  = StockTickerSymbol
        self.LastPrice = LastPrice
        self.ChangePercent = ChangePercent
        self.Timestamp = Timestamp
        self.Open = Open
        self.PreviousClose = PreviousClose
        self.DailyRange = DailyRange
        self.Volume = Volume
        self.change_price = change_price
    }
}
