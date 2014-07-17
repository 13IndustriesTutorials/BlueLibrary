//
//  Album+TableRepresentation.swift
//  BlueLibrary
//
//  Created by user on 7/15/14.
//  Copyright (c) 2014 someCompanyNameHere. All rights reserved.
//

import UIKit

extension Album {
   
    func tableRepresentation()->NSDictionary!
    {
        var keys:NSArray = ["Artist", "Album", "Genre",  "Year"]
        var data:NSArray = [self.artist!, self.title!, self.genre!, self.year!]
        var albumInfo = ["titles": keys,"values": data]
        
        return albumInfo
    }
}
