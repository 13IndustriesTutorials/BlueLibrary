//
//  LibraryAPI.swift
//  BlueLibrary
//
//  Created by user on 7/15/14.
//  Copyright (c) 2014 someCompanyNameHere. All rights reserved.
//

import UIKit

class LibraryAPI: NSObject {
   
    class var sharedInstance:LibraryAPI
    {
        struct Singleton
        {
            static let instance = LibraryAPI()
        }
        
        return Singleton.instance
    }

}
