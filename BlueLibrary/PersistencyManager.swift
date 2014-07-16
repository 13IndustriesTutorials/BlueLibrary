//
//  PersistencyManager.swift
//  BlueLibrary
//
//  Created by user on 7/15/14.
//  Copyright (c) 2014 someCompanyNameHere. All rights reserved.
//

import UIKit

class PersistencyManager: NSObject {
   
    var albums:Album[]
    
    init()
    {
        var album1 = Album(title: "Best of Bowie", artist: "David Bowie", genre: "Pop", coverUrl: "http://www.coversproject.com/static/thumbs/album/album_david%20bowie_best%20of%20bowie.png", year: "1992")
        
        var album2 = Album(title: "It's My Life", artist: "No Doubt", genre: "Pop", coverUrl: "http://www.coversproject.com/static/thumbs/album/album_no%20doubt_its%20my%20life%20%20bathwater.png", year: "2003")
        
        var album3 = Album(title: "Nothing Like The Sun", artist: "Sting", genre: "Pop", coverUrl: "http://www.coversproject.com/static/thumbs/album/album_sting_nothing%20like%20the%20sun.png", year: "1999")
        
        var album4 = Album(title: "Staring at the Sun", artist: "U2", genre: "Pop", coverUrl: "http://www.coversproject.com/static/thumbs/album/album_u2_staring%20at%20the%20sun.png", year: "2000")
        
        var album5 = Album(title: "American Pie", artist: "American Pie", genre: "Pop", coverUrl:"http://www.coversproject.com/static/thumbs/album/album_madonna_american%20pie.png", year: "2000")
        
        self.albums = [album1, album2, album3, album4, album5]
    }
    
    
    func getAlbums()->Album[]!
    {
        return self.albums
    }
    
    
    func addAlbum(album:Album, index:Int)
    {
        if self.albums.count >= index
        {
            self.albums.insert(album, atIndex: index)
        }
    }
    
    
    func deleteAlbumAtIndex(index:Int)
    {
        self.albums.removeAtIndex(index)
    }
}
