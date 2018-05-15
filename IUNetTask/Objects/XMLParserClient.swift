//
//  XMLParserClient.swift
//  IUNetTask
//
//  Created by User on 5/14/18.
//  Copyright © 2018 Hamest. All rights reserved.
//

import UIKit
import Foundation


class XMLParserClient: NSObject, XMLParserDelegate {
    var parser = XMLParser()
    var newsData = [Dictionary<String, Any>]()
    var newsModel: Dictionary<String, Any>?
    var foundElementName: String?
    var title: String?
    var date: String?
    var desc: String?
    var articleUrl: String?
    var tumbnailUrl: String?
    
    var error: Error? = nil
    
    static var client: XMLParserClient?
    
    static func sharedInstance() -> XMLParserClient {
        if client == nil {
            client = XMLParserClient()
        }
        
        return client!
    }
    
    func xmlSerialization(withObjects articls:[Dictionary<String, Any>]) -> (Data){
        var dataStr: String = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><rss>"
        for element in articls {
            let componentArray: Array = Array(element.keys)
            var elementStr: String = "<item>"
            for key in componentArray {
                let prefStr: String = "<" + key + ">"
                let sufStr: String = "</" + key + ">"
                let midStr: String = element[key] as! String
                let str :String = prefStr + midStr + sufStr
                elementStr.append(str)
            }
            elementStr.append("</item>")
            dataStr.append(elementStr)
        }
        dataStr.append("</rss>")
        let data = dataStr.data(using: .utf8)

        return data!
    }
    func fetchXMLData(for url: String, withCallback completionHandler: @escaping (_ result: [Dictionary<String, Any>]?, _ error: Error?) -> Void) {
        parser = XMLParser.init(contentsOf: URL(string: url)!)!
        parser.delegate = self
        
        if parser.parse() {
            if error != nil {
                completionHandler(nil, error)
            }
            else {
                completionHandler(newsData, nil)
            }
        }
        else {
            let newError = NSError(domain:"", code: 400, userInfo: [NSLocalizedDescriptionKey: "Error while parsing"])
            completionHandler(nil, newError)
        }
    }
    
    // MARK: - XMLParserDelegate
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        foundElementName = elementName
        if elementName == "item" {
            newsModel = Dictionary()
            title = ""
            date = ""
            desc = ""
            articleUrl = ""
            tumbnailUrl = ""
            foundElementName = ""
        }
        if foundElementName == "media:thumbnail" {
            tumbnailUrl = attributeDict["url"]
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        let trimmedString = string.trimmingCharacters(in: .whitespaces)
        if trimmedString != "\n"
        {
            if foundElementName == "title" {
                title?.append(string)
            } else if foundElementName == "pubDate" {
                date?.append(string)
            }
            else if foundElementName == "description" {
                desc?.append(string)
            } else if foundElementName == "link" {
                articleUrl?.append(trimmedString)
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            if title != nil {
                newsModel?["title"] = title!
            }
            if date != nil {
                let dateFormatter = DateFormatter()
                //Your current Date Format
                dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                let finaldate = dateFormatter.date(from:date!)
                
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                let second = dateFormatter.string(from: finaldate!)
                newsModel?["publishedAt"] = second
            }
            if desc != nil {
                newsModel?["description"] = desc!
            }
            if articleUrl != nil {
                newsModel?["url"] = articleUrl!
            }
            if tumbnailUrl != nil {
                newsModel?["urlToImage"] = tumbnailUrl!
            }
            newsData.append(newsModel!)
            newsModel = nil
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("failure error: ", parseError)
        error = parseError
    }
}
