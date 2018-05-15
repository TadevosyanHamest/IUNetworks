//
//  ViewController.swift
//  IUNetTask
//
//  Created by User on 5/11/18.
//  Copyright © 2018 Hamest. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var articleList: [Article] = []
    var currentUrl: String = ""


    override func viewDidLoad() {
        super.viewDidLoad()
        Helper.sharedInstance.getJsonData() { list in
            self.articleList += list
            self.reloadTableData()

        }
        Helper.sharedInstance.getXMLData() { list in
            self.articleList += list
            self.reloadTableData()
        }
    }
    
    func reloadTableData(){
        self.articleList = self.articleList.sorted(by: {$0.date! >  $1.date!})

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
        let article = articleList[indexPath.row]
        
        cell.titleLabel?.text = article.title
        cell.descriptionLabel?.text = article.articleDescription
        cell.publishedDateLabel?.text = article.publishedDate
        if cell.articleImageView?.image == nil  || cell.imageUrl != article.url{
            let url = URL(string: article.thumbnailImage!)
            cell.articleImageView.image = UIImage(named: "Newspaper-Icon")
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    cell.articleImageView.image = UIImage(data: data!)
                    cell.articleImageView.contentMode = UIViewContentMode.scaleAspectFit
                    cell.imageUrl = article.url
                }
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articleList[indexPath.row]
        self.currentUrl = article.url!
        performSegue(withIdentifier: "toWebView", sender: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWebView" {
            if let viewController = segue.destination as? WebViewController {
                viewController.url = self.currentUrl
            }
        }
    }
    
    // MARK: - Actions

    @IBAction func saveAsJsonButtonAction(_ sender: Any) {
        let infoList = self.articleList.map { $0.info }
        Helper.sharedInstance.saveToJsonFile(articls: infoList)
    }
    
    @IBAction func saveAsXmlButtonAction(_ sender: Any) {
        let infoList = self.articleList.map { $0.info }
        Helper.sharedInstance.saveToXmlFile(articls: infoList)
    }
    
}
