//
//  AlbumView.swift
//  BlueLibrary
//
//  Created by user on 7/15/14.
//  Copyright (c) 2014 someCompanyNameHere. All rights reserved.
//

import UIKit
import Foundation

class AlbumView: UIView {

    var albumCover:String?
    var coverImage:UIImageView?
    var activityIndicatorView:UIActivityIndicatorView?
    
    init(frame: CGRect) {
        
        self.activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle:UIActivityIndicatorViewStyle.White)
        super.init(frame: frame)
    }
    
    init(frame: CGRect, albumCover:String) {
        
        super.init(frame: frame)
        
        self.albumCover = albumCover;
        self.backgroundColor = UIColor.blackColor()
        self.coverImage = UIImageView(frame: CGRectMake(5, 5, self.frame.size.width-10, self.frame.size.height-10))
        self.addSubview(self.coverImage)
        
        
        self.activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle:UIActivityIndicatorViewStyle.WhiteLarge)
        self.activityIndicatorView!.center = self.center
        self.activityIndicatorView!.startAnimating()
        self.addSubview(self.activityIndicatorView)
        
        self.coverImage!.addObserver(self, forKeyPath: "image", options: NSKeyValueObservingOptions.New, context: nil)
        
        //create a userInfo dictionary to pass to object receiving notification
        //create empty dictionary with String keys and AnyObject type values
        var albumInfo = Dictionary<String,AnyObject>()
    
        //you have to unwrap optionals before adding to dictionary
        albumInfo["imageView"] = self.coverImage!
        albumInfo["coverURL"] = self.albumCover!

        //post a notification to let objects know the view was created and the album cover needs to be downloaded
        let notificationCenter = NSNotificationCenter.defaultCenter()!
        notificationCenter.postNotificationName("BLDownloadImageNotification", object:self, userInfo:albumInfo)

    }
    
    override func observeValueForKeyPath(keyPath: String!, ofObject object: AnyObject!, change: NSDictionary!, context: CMutableVoidPointer)
    {
        if keyPath == "image"
        {
            self.activityIndicatorView!.stopAnimating()
        }
    }
    
    deinit
    {
        self.removeObserver(self, forKeyPath: nil)
    }
    
}
