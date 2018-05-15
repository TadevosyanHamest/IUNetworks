//
//  Helper.swift
//  IUNetTask
//
//  Created by User on 5/13/18.
//  Copyright © 2018 Hamest. All rights reserved.
//

import UIKit

class Helper: NSObject,XMLParserDelegate {
    let urlWirtJsonDate = "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=97ba815035ae4381b223377b2df975ab"
    let urlWirtXmlDate  = "http://feeds.bbci.co.uk/news/video_and_audio/technology/rss.xml"
    
    static let sharedInstance = Helper()
    
    private override init() {
    }
    
    func getJsonData(completion: @escaping ([Article]) -> Void ) {
        guard let urlAddress = URL(string: urlWirtJsonDate) else { return }
        
        var request = URLRequest(url: urlAddress)
        request.timeoutInterval = 30.0
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("\(error.localizedDescription)")
            }
            if (response as? HTTPURLResponse) != nil {
                let reap = response as? HTTPURLResponse
                if reap?.statusCode == 200 {
                    do {
                        guard let jsonData = try JSONSerialization.jsonObject(with: data!, options: [])
                            as? [String: Any] else {
                                print("error trying to convert data to JSON")
                                return
                        }
                        let status = jsonData["status"]! as AnyObject
                        guard let okStatus = status as? String else {
                            print("error")
                            return
                        }
                        if (okStatus == "ok") {
                            let list = jsonData["articles"]! as AnyObject
                            guard let artiles = list as? NSArray else {
                                print("error")
                                return
                            }
                            completion(self.getObjectList(list: artiles))
                        }
                    } catch  {
                        print("error trying to convert data to JSON")
                        return
                    }
                }
                
            }
        }
        task.resume()
    }

    func getXMLData(completion: @escaping ([Article]) -> Void) {
        
        XMLParserClient.sharedInstance().fetchXMLData(for: urlWirtXmlDate) { (newsModelList, error) in

            print("Fetch data  Factory ", newsModelList?.count ?? "0")
            if error == nil {
                completion(self.getObjectList(list: newsModelList! as NSArray))
            }
            else {
                return
            }
        }
    }
    
    func getObjectList(list:NSArray) ->[Article] {
        var articleList : [Article] = []
        for element in list {
            guard let artileDic = element as? Dictionary<String, Any> else {
                return articleList
            }
            let article = Article(data: artileDic)
            articleList.append(article)
        }
        return articleList
    }
    
    func saveToJsonFile(articls:Any) {
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentDirectoryUrl.appendingPathComponent("Articls.json")
       print(documentDirectoryUrl)
        do {
            let data = try JSONSerialization.data(withJSONObject: articls, options: [])
            try data.write(to: fileUrl, options: [])
        } catch {
            print(error)
        }
    }
    func saveToXmlFile(articls:[Dictionary<String, Any>]) {
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentDirectoryUrl.appendingPathComponent("Articls.xml")
        print(documentDirectoryUrl)
        do {
            let data = XMLParserClient.sharedInstance().xmlSerialization(withObjects: articls)
            try data.write(to: fileUrl)
        } catch {
            print(error)
        }
    }
    
}
