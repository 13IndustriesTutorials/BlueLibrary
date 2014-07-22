//
//  LibraryAPI.swift
//  BlueLibrary
//
//  Created by user on 7/15/14.
//  Copyright (c) 2014 someCompanyNameHere. All rights reserved.
//

import UIKit
import Foundation

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
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"downloadImage:", name: "BLDownloadImageNotification", object: nil)
        
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
    
    func downloadImage(notification:NSNotification)
    {
        //println("\(notification)")
        
        //THE PROBLEM IS WITH THE UIIMAGEVIEW
        var imageView = notification.userInfo["imageView"] as UIImageView
        //println("\(imageView)")
        
        let coverURL = notification.userInfo["coverURL"] as NSString
        //println("\(coverURL)")
        
        //check if the image has been save previously
        imageView.image = self.persistencyManager!.getImage(coverURL)
        
        //the image is not save, so download it now
        if imageView.image == nil
        {
            //download the image asynchronously
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),{
                
                let image = self.httpClient!.downloadImage(coverURL)
                
                //back on main thread
                dispatch_async(dispatch_get_main_queue(), {
                    
                    //update the view
                    if image != nil
                    {
                        imageView.image = image;
                        
                        //save the image
                        self.persistencyManager!.saveImage(image, filename: coverURL)
                    }
                    
                })
            })
        }
    }
    
}















