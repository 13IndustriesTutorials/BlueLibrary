//
//  HTTPClient.swift
//  BlueLibrary
//
//  Created by user on 7/15/14.
//  Copyright (c) 2014 someCompanyNameHere. All rights reserved.
//

import UIKit

class HTTPClient: NSObject {
   
    
    func getRequest(url:String)->AnyObject!
    {
        return nil
    }
    
    func postRequest(url:String, body:String)->AnyObject!
    {
        return nil
    }
    
    func downloadImage(url:String)->UIImage
    {
        let fileURL:NSURL = NSURL(string: url)
        let data = NSData(contentsOfURL:fileURL)
        return UIImage(data: data)
    }
    
}
