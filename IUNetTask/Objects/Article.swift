//
//  Article.swift
//  IUNetTask
//
//  Created by User on 5/13/18.
//  Copyright © 2018 Hamest. All rights reserved.
//

import UIKit

class Article: NSObject {
    var title: String?
    var articleDescription: String?
    var publishedDate: String?
    var date: Date?
    var thumbnailImage: String?
    var url: String?
    var info: Dictionary<String, String>
    init(data: Dictionary<String, Any>) {
        self.title = data["title"] as? String
        self.articleDescription = data["description"] as? String
        self.publishedDate = data["publishedAt"] as? String
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        self.date = dateFormatter.date (from: self.publishedDate! )
        self.thumbnailImage = data["urlToImage"] as? String
        self.url = data["url"] as? String
        self.info = ["title": self.title ,"description": self.articleDescription,"publishedAt": self.publishedDate, "urlToImage": self.thumbnailImage,"url": self.url] as! Dictionary<String, String>
    }
    
}
