//
//  DetailVC.swift
//  flickr
//
//  Created by Daniel Maia dos Passos on 27/07/15.
//  Copyright (c) 2015 Creative Lab. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class DetailVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var tb: UITableView!
    
    var id: String!
    var tit: String!
    var desc: String!
    var user: String!
    var views: String!
    var farm: Int!
    var server: String!
    var secret: String!
    var photoDetail: PhotoDetail!
    
    let apiKey = "06975073619d9a5fcbae3918207630bf"
    let aux = "&format=json"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        SwiftSpinner.show("Carregando dados ..", animated: true)
        
        tb.delegate = self
        tb.dataSource = self
        
        self.tb.estimatedRowHeight = 48
        self.tb.rowHeight = UITableViewAutomaticDimension
        
        var bg = UIView(frame: CGRectZero)
        self.tb.tableFooterView = bg
        getData()
       
    }
    
    func tableView(tb: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.photoDetail == nil {
            return 0
        } else{
            return 4
        }
    }
    
    func tableView(tb: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tb.dequeueReusableCellWithIdentifier("CellIdDetail", forIndexPath: indexPath) as! DetailTVC
        
        if self.photoDetail != nil {
            
            switch indexPath.row {
                
            case 0:
                cell.lblField.text = "Título:"
                cell.lblValue.textColor = UIColor.brownColor()
                
                if self.photoDetail.title == "" {
                    cell.lblValue.text = "Foto sem título"
                    cell.lblValue.textColor = UIColor.grayColor()
                    cell.lblValue.font = UIFont(name:"AvenirNext-italic", size: 15.0)
                } else {
                    cell.lblValue.text = self.photoDetail.title
                }
            case 1:
                cell.lblField.text = "Descrição:"
                cell.lblValue.textColor = UIColor.brownColor()
                
                if self.photoDetail.desc == "" {
                    cell.lblValue.text = "Foto sem descrição"
                    cell.lblValue.textColor = UIColor.grayColor()
                    cell.lblValue.font = UIFont(name:"AvenirNext-italic", size: 15.0)
                } else {
                    cell.lblValue.text = self.photoDetail.desc
                }
            case 2:
                cell.lblField.text = "Usuário:"
                cell.lblValue.textColor = UIColor.brownColor()
                
                if self.photoDetail.user == "" {
                    cell.lblValue.text = "Foto sem descrição de usuário"
                    cell.lblValue.textColor = UIColor.grayColor()
                    cell.lblValue.font = UIFont(name:"AvenirNext-italic", size: 15.0)
                } else {
                    cell.lblValue.text = self.photoDetail.user
                }
            case 3:
                cell.lblField.text = "Visualizações:"
                cell.lblValue.textColor = UIColor.brownColor()
                cell.lblValue.text = self.photoDetail.views

            default:
                cell.lblField.text = ""
                cell.lblValue.text = ""
            }
            SwiftSpinner.hide()
        }
        
        return cell
    }
    
    func getData() -> Void {
        
        let baseURL = "https://api.flickr.com/services/rest/?method=flickr.photos.getInfo"
        let apiString = "&api_key=\(apiKey)"
        let idString = "&photo_id=\(self.id)"
        let auxString =  "&format=json&nojsoncallback=1"
        
        let requestURL = (string: baseURL + apiString + idString + auxString)
        
        Alamofire.request(.GET, requestURL).responseJSON { (_, _, json, error) in
            if(error != nil) {
                NSLog("Error: \(error)")
            } else {
                
                var json = JSON(json!)
                
                let count: Int? = json["photo"].array?.count
                println(count)
                println("id: \(self.id)")
                
                if let titJson = json["photo"]["title"]["_content"].string {
                    self.tit = titJson
                }
                
                if let descJson = json["photo"]["description"]["_content"].string {
                    self.desc = descJson
                }
                
                if let userJson = json["photo"]["owner"]["username"].string {
                    self.user = userJson
                }
                
                if let viewsJson = json["photo"]["views"].string {
                    self.views = viewsJson
                }
                
                if let farmJson = json["photo"]["farm"].int {
                    self.farm = farmJson
                }
                
                if let serverJson = json["photo"]["server"].string {
                    self.server = serverJson
                }
                
                if let secretJson = json["photo"]["secret"].string {
                    self.secret = secretJson
                }
                
                self.photoDetail = PhotoDetail(mId: self.id, mTitle: self.tit, mDesc: self.desc, mUserName: self.user, mViews: self.views, mFarm: self.farm, mServer: self.server, mSecret: self.secret)
                
                var imageString:String = "http://farm\(self.photoDetail.farm).staticflickr.com/\(self.photoDetail.server)/\(self.id)_\(self.secret)_n.jpg/"
                
                if imageString != "" {
                    LazyImage.showForImageView(self.img, url: imageString)
                }
                self.tb.reloadData()
            }
        }
    }
}




