//
//  ViewController.swift
//  json
//
//  Created by Ryan Welch on 5/6/17.
//  Copyright © 2017 Ryan Welch. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    final let nrmlUrl = "https://www.oneness287.com/collections/all/products.json" // Change this URL to any shopify URL with products.json as the ending
    
    @IBOutlet weak var tableView: UITableView!
    
    // Different arrays to store different information
    var titleArray = [String]()
    var pricesArray = [String]()
    var imgURLArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.downloadJSONFromUrl()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Function to download the JSON and append it to the arrays
    func downloadJSONFromUrl()
    {
        let url = URL(string: nrmlUrl)
        URLSession.shared.dataTask(with: (url)!, completionHandler: {(data, response, error) ->
            Void in
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                as? NSDictionary {
                print(jsonObj!.value(forKey: "products")!)
                
                if let productArray = jsonObj!.value(forKey: "products") as? NSArray {
                    for titles in productArray {
                        if let titlesDict = titles as? NSDictionary {
                            if let title = titlesDict.value(forKey: "title") {
                                self.titleArray.append(title as! String)
                            }
                            if let variants = jsonObj!.value(forKey: "variants") as? NSArray {
                                for prices in variants {
                                    if let pricesDict = prices as? NSDictionary {
                                        if let price = pricesDict.value(forKey: "price") {
                                            self.pricesArray.append((price as? String)!)
                                        }
                                        
                                    }
                                }
                            }
//                            if let title = titlesDict.value(forKey: "price") {
//                                self.pricesArray.append(title as! String)
//                            }
//                            if let title = titlesDict.value(forKey: "title") {
//                                imgURL.append(title as! String)
//                            }
                            
                            OperationQueue.main.addOperation({
                                self.tableView.reloadData()
                            })
                        }
                    }
                }
            }
        }).resume()
    }
    
    // Prints out the JSON data
    func downloadJSONWithTask()
    {
        let url = URL(string: nrmlUrl)
        
        var downloadTask = URLRequest(url: (url)!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 20)
        
        var downloadRequest = URLRequest(url: (nrmlUrl as? URL)!)
        
        downloadTask.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: downloadTask, completionHandler: {(data, response, error) ->
            Void in
            
            let jsonData = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
        
            print(jsonData!)
        }).resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
//        cell.productPrice.text = pricesArray[indexPath.row]
        cell.productName.text = titleArray[indexPath.row]
        
//        let imgURL = NSURL(string: imgURLArray[indexPath.row])
//        if imgURL != nil{
//            let data = NSData(contentsOf: (imgURL as URL?)!)
//            cell.productImage.image = UIImage(data: data! as Data)
//        }
        return cell
        
    }
}

