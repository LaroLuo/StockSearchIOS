//
//  news.swift
//  hw9
//
//  Created by Rui Luo on 11/28/17.
//  Copyright © 2017 Rui Luo. All rights reserved.
//

import Foundation

class News{
    var newsTitle : String
    var newsAuthor : String
    var newsPubDate : String
    var newsLink : String
    init(title: String, author: String, pubDate : String, link : String) {
        self.newsTitle  = title
        self.newsAuthor = author
        self.newsPubDate  = pubDate
        self.newsLink = link
    }
}
