//
//  WebViewController.swift
//  IUNetTask
//
//  Created by User on 5/13/18.
//  Copyright © 2018 Hamest. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    var url: String!
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWebView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadWebView() {
        print(self.url)
        let loadedUrl = NSURL (string: self.url);
        let requestObj = NSURLRequest(url: loadedUrl! as URL)
        webView.loadRequest(requestObj as URLRequest)
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
