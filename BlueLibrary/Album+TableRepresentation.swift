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
        //var keys = ["Artist", "Album", "Genre",  "Year"]
        //var data = [self.artist, self.title, self.genre, self.year]
        var albumInfo = ["titles": ["Artist", "Album", "Genre",  "Year"],"values": [self.artist, self.title, self.genre, self.year]]
        
        return albumInfo
    }
}
