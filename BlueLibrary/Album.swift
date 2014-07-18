//
//  Album.swift
//  BlueLibrary
//
//  Created by user on 7/15/14.
//  Copyright (c) 2014 someCompanyNameHere. All rights reserved.
//

import UIKit

class Album {
   
    var title:String?
    var artist:String?
    var genre:String?
    var coverUrl:String?
    var year:String?
    
    init(title:String, artist:String, genre:String, coverUrl:String, year:String)
    {
        self.title = title
        self.artist = artist
        self.genre = genre
        self.coverUrl = coverUrl
        self.year = year
        
    }
}
