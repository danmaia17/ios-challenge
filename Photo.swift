//
//  Photo.swift
//  flickr
//
//  Created by Daniel Maia dos Passos on 26/07/15.
//  Copyright (c) 2015 Creative Lab. All rights reserved.
//

import Foundation

class Photo {
    
    var id: String!
    var title: String!
    var farm: Int!
    var server: String!
    var secret: String!
    
    init(mId: String, mTitle: String, mFarm: Int, mServer: String, mSecret: String) {
        self.id = mId
        self.title = mTitle
        self.farm = mFarm
        self.server = mServer
        self.secret = mSecret
    }
    
}
