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
        
        super.init()
        
        //register as observer to be notified when ablumview is loaded
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "downloadImage", name: "BLDownloadImageNotification", object: nil)
        
    }
    
    //create deinitializer
    deinit{
        //deregister for notifications
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
            self.httpClient!.postRequest("/api/addAlbum", body:"\(index.description)")
        }
    }
    
    
    func deleteAlbumAtIndex(index:Int)
    {
        self.persistencyManager!.deleteAlbumAtIndex(index)
        
        if isOnline
        {
            self.httpClient!.postRequest("/api/deleteAlbum", body:"\(index.description)")
        }
    }

}
