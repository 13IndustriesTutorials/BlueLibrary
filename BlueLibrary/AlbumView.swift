//
//  AlbumView.swift
//  BlueLibrary
//
//  Created by user on 7/15/14.
//  Copyright (c) 2014 someCompanyNameHere. All rights reserved.
//

import UIKit

class AlbumView: UIView {

    var albumCover:String?
    var coverImage:UIImageView?
    var activityIndicatorView:UIActivityIndicatorView?
    
    init(frame: CGRect) {
        
        self.albumCover = nil;
        self.activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle:UIActivityIndicatorViewStyle.White)
        super.init(frame: frame)
    }
    
    init(frame: CGRect, albumCover:String) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.blackColor()
        self.albumCover = albumCover;
        self.coverImage = UIImageView(frame: CGRectMake(5, 5, self.frame.size.width-10, self.frame.size.height-10))
        self.addSubview(self.coverImage)
        
        
        self.activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle:UIActivityIndicatorViewStyle.WhiteLarge)
        self.activityIndicatorView!.center = self.center
        self.activityIndicatorView!.startAnimating()
        self.addSubview(self.activityIndicatorView)
        
        //create a userInfo dictionary to pass to object receiving notification
        var userInfo = Dictionary<String,Any>()  //create empty dictionary
        userInfo["imageview"] = coverImage
        userInfo["coverURL"] = albumCover
        
        //create notification
        NSNotificationCenter.defaultCenter().postNotificationName("", object: self, userInfo:userInfo )

    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
    }
    */

}
