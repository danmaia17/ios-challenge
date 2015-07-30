//
//  MainTableView.swift
//  flickr
//
//  Created by Daniel Maia dos Passos on 26/07/15.
//  Copyright (c) 2015 Creative Lab. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner
import SystemConfiguration

class MainTableView: UITableViewController {
    

    @IBOutlet var tb: UITableView!

    var id: String!
    var tit: String!
    var farm: Int!
    var server: String!
    var secret: String!
    var photos = [Photo]()
    let apiKey = "06975073619d9a5fcbae3918207630bf"
    let aux = "&format=json&nojsoncallback=1"
    var imageString:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        SwiftSpinner.show("Carregando dados ..", animated: true)
        
        self.tb.estimatedRowHeight = 44
        self.tb.rowHeight = UITableViewAutomaticDimension
        
        var bg = UIView(frame: CGRectZero)
        self.tb.tableFooterView = bg
        self.tb.backgroundColor = UIColor.whiteColor()
        
        self.navigationController?.popViewControllerAnimated(true)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        if Reachability.isConnectedToNetwork() == true {
            getData()
        } else {
            var alert = UIAlertController(title: "Ops!", message: "Não conectado a internet.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            SwiftSpinner.hide()
        }
        
        self.tb.addPullToRefresh({ [weak self] in
            self?.photos.removeAll(keepCapacity: false)
            self!.getData()
            self?.tb.reloadData()
            self?.tb.stopPullToRefresh()
        })


    }
    
    func refresh(sender:AnyObject)
    {
        // Updating your data here...
        
        self.tb.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "segue") {
            if let indexPath = tableView.indexPathForSelectedRow() {
                let detailViewController = segue.destinationViewController as! DetailVC
                detailViewController.id = self.photos[indexPath.row].id
            }
        }
    }


    override func tableView(tb: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.photos.count) == 0 {
            return 0
        } else {
            return self.photos.count
        }
    }
    
    

    
    override func tableView(tb: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tb.dequeueReusableCellWithIdentifier("CellIdentifier", forIndexPath: indexPath) as! MainTVC
        
        if self.photos.count > 0 {
            let p = self.photos[indexPath.row]
            
            if p.title == "" {
                cell.lblTitle.text = "Foto sem título"
                cell.lblTitle.textColor = UIColor.grayColor()
                cell.lblTitle.font = UIFont(name:"AvenirNext-italic", size: 15.0)
            } else {
                cell.lblTitle.text = p.title
                cell.lblTitle.textColor = UIColor.brownColor()
                cell.lblTitle.font = UIFont(name:"AvenirNext-regular", size: 17.0)
            }
            
            var idt:String = p.id
            var farm:Int = p.farm
            var server:String = p.server
            var secret:String = p.secret
            var imageString:String = "http://farm\(farm).staticflickr.com/\(server)/\(idt)_\(secret)_n.jpg/"
            
            LazyImage.showForImageView(cell.img, url: imageString)
            SwiftSpinner.hide()
        }

        // Configure the cell...
        
        cell.lblTitle.preferredMaxLayoutWidth = CGRectGetWidth(cell.lblTitle.frame)
        return cell
    }
    
    

    
    
    func getData() -> Void {
        
        let baseURL = "https://api.flickr.com/services/rest/?&method=flickr.photos.getRecent"
        let apiString = "&api_key=\(apiKey)"
        let auxString = "&tags=\(aux)"
        
        let requestURL = (string: baseURL + apiString + auxString)
        
        let firstRequest =  Alamofire.request(.GET, requestURL).responseJSON { (_, _, json, error) in
            if(error != nil) {
                NSLog("Error: \(error)")
            } else {
                
                var json = JSON(json!)
                
                let count: Int? = json["photos"]["photo"].array?.count
                
                if let ct = count {
                    for index in 0...ct-1 {
                        if let idJson = json["photos"]["photo"][index]["id"].string {
                            self.id = idJson
                        }
                        
                        if let titJson = json["photos"]["photo"][index]["title"].string {
                            self.tit = titJson
                        }
                        
                        if let farmJson = json["photos"]["photo"][index]["farm"].int {
                            self.farm = farmJson
                        }
                        
                        if let serverJson = json["photos"]["photo"][index]["server"].string {
                            self.server = serverJson
                        }
                        
                        if let secretJson = json["photos"]["photo"][index]["secret"].string {
                            self.secret = secretJson
                        }
                        
                        let p = Photo(mId: self.id,  mTitle: self.tit, mFarm: self.farm, mServer: self.server, mSecret: self.secret)
                        self.photos += [p]
                    }
                }
                self.tb.reloadData()
                
            }
        }
    }

}
