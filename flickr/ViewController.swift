//
//  ViewController.swift
//  flickr
//
//  Created by Daniel Maia dos Passos on 24/07/15.
//  Copyright (c) 2015 Creative Lab. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
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
        // Do any additional setup after loading the view, typically from a nib.
        
        let baseURL = "https://api.flickr.com/services/rest/?&method=flickr.photos.getRecent"
        let apiString = "&api_key=\(apiKey)"
        let auxString = "&tags=\(aux)"
    
        let requestURL = (string: baseURL + apiString + auxString)
        
        println(requestURL)
        

        Alamofire.request(.GET, requestURL).responseJSON { (_, _, json, error) in
                if(error != nil) {
                    NSLog("Error: \(error)")
                } else {
                    var json = JSON(json!)
                    println(json)
                    
                    let count: Int? = json["photos"]["photo"].array?.count
                    println(count)
                    println("")
                    
                    if let ct = count {
                        for index in 0...ct-1 {
                            if let idJson = json["photos"]["photo"][index]["id"].string {
                                self.id = idJson
                                println(self.id)
                            }
                            
                            if let titJson = json["photos"]["photo"][index]["title"].string {
                                self.tit = titJson
                                println(self.tit)
                            }
                            
                            if let farmJson = json["photos"]["photo"][index]["farm"].int {
                                self.farm = farmJson
                                println(self.farm)
                            }
                            
                            if let serverJson = json["photos"]["photo"][index]["server"].string {
                                self.server = serverJson
                                println(self.server)
                            }
                            
                            if let secretJson = json["photos"]["photo"][index]["secret"].string {
                                self.secret = secretJson
                                println(self.secret)
                            }
                            
                            println("------------------------------")
                            println("")
                            println("")
                            
                            let p = Photo(mId: self.id,  mTitle: self.tit, mFarm: self.farm, mServer: self.server, mSecret: self.secret)
                            //self.photos.append(p)
                            //self.photos.insert(p, atIndex:index)
                            self.photos += [p]
                        }
                    }

                    
                    var idt:String = json["photos"]["photo"][0]["id"].stringValue
                    var farm:String = json["photos"]["photo"][0]["farm"].stringValue
                    var server:String = json["photos"]["photo"][0]["server"].stringValue
                    var secret:String = json["photos"]["photo"][0]["secret"].stringValue
                    var imageString:String = "http://farm\(farm).staticflickr.com/\(server)/\(idt)_\(secret)_n.jpg/"
                    println(imageString)
                    self.urlToImageView(imageString)
                    
                    
                    let p1 = self.photos[1]
                    println(p1.id)
                    
                    let p2 = self.photos[2]
                    println(p2.id)
                    
                    println(self.photos.count)
                    
                }
        }
       
    }
    
    //Apresenta a imagem de forma assincrona
    func urlToImageView(imageString: String){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            dispatch_async(dispatch_get_main_queue(), {
                let url = NSURL(string: imageString)
                let imageData = NSData(contentsOfURL: url!)
                if(imageData != nil){
                    //self.imageView.image = UIImage(data: imageData!)
                    println("1")
                } else {
                    println("2")
                    self.urlToImageView(imageString)
                }
                
            });
        });
        
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

