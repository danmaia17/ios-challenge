//
//  PhotoDetail.swift
//  flickr
//
//  Created by Daniel Maia dos Passos on 27/07/15.
//  Copyright (c) 2015 Creative Lab. All rights reserved.
//

import Foundation

class PhotoDetail {
    
    var id: String!
    var title: String!
    var desc: String!
    var user: String!
    var views: String!
    var farm: Int!
    var server: String!
    var secret: String!
    
    init(mId: String, mTitle: String, mDesc: String, mUserName: String, mViews: String, mFarm: Int, mServer: String, mSecret: String) {
        self.id = mId
        self.title = mTitle
        self.desc = mDesc
        self.user = mUserName
        self.views = mViews
        self.farm = mFarm
        self.server = mServer
        self.secret = mSecret
    }
    
    
    
}