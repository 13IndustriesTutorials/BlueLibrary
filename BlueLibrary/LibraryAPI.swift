//
//  LibraryAPI.swift
//  BlueLibrary
//
//  Created by user on 7/15/14.
//  Copyright (c) 2014 someCompanyNameHere. All rights reserved.
//

import UIKit

class LibraryAPI: NSObject {
   
    var persistencyManager:PersistencyManager?
    var httpClient:HTTPClient?
    var isOnline:Bool
    
    class var sharedInstance:LibraryAPI
    {
        struct Singleton
        {
            static let Instance = LibraryAPI()
        }
        
        return Singleton.Instance
    }
    
    init()
    {
        self.persistencyManager = PersistencyManager()
        self.httpClient = HTTPClient()
        self.isOnline = false;
    }
    
    func getAlbums()->AnyObject[]!
    {
        return self.persistencyManager!.getAlbums()
    }
    
    
    func addAlbum(album:Album, index:Int)
    {
       self.persistencyManager!.addAlbum(album, index: index)
        
        if isOnline
        {
            
        }
    }
    
    
    func deleteAlbumAtIndex(index:Int)
    {
        self.persistencyManager!.deleteAlbumAtIndex(index)
    }

}
