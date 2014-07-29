//
//  Album.swift
//  BlueLibrary
//
//  Created by user on 7/15/14.
//  Copyright (c) 2014 someCompanyNameHere. All rights reserved.
//

import UIKit

class Album: NSObject,NSCoding
{
   
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
    
    init(coder aDecoder: NSCoder!)
    {
        self.title = aDecoder.decodeObjectForKey("album") as? String
        self.artist = aDecoder.decodeObjectForKey("artist") as? String
        self.genre = aDecoder.decodeObjectForKey("genre") as? String
        self.coverUrl = aDecoder.decodeObjectForKey("cover_url") as? String
        self.year = aDecoder.decodeObjectForKey("year") as? String
    }
    
    func encodeWithCoder(aCoder: NSCoder!)
    {
        aCoder.encodeObject(self.year, forKey: "year")
        aCoder.encodeObject(self.title, forKey: "album")
        aCoder.encodeObject(self.artist, forKey: "artist")
        aCoder.encodeObject(self.coverUrl, forKey: "cover_url")
        aCoder.encodeObject(self.genre, forKey: "genre")
        
    }
}
