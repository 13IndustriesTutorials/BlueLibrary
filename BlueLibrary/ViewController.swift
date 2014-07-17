//
//  ViewController.swift
//  BlueLibrary
//
//  Created by user on 7/15/14.
//  Copyright (c) 2014 someCompanyNameHere. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    var allAlbums:AnyObject[]?
    var currentAlbumData:NSDictionary?
    var currentAlbumIndex:Int
    @IBOutlet var tableView : UITableView
    
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        self.currentAlbumIndex = 0;
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.backgroundColor = UIColor(red: 0.76, green: 0.81, blue: 0.87, alpha: 1.0)
        self.allAlbums = LibraryAPI.sharedInstance.getAlbums()
        self.showDataForAlbumAtIndex(self.currentAlbumIndex)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func tableView(tableView: UITableView!,numberOfRowsInSection section: Int) -> Int
    {
        return (self.currentAlbumData!.objectForKey("titles") as AnyObject[]).count
    }
    
    func tableView(tableView: UITableView!,cellForRowAtIndexPath indexPath: NSIndexPath!) ->UITableViewCell!
    {
        let cellIdentifier = "cellIdentifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        
        if !cell{
            
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
        }
        
        var titles:NSArray = self.currentAlbumData!.objectForKey("titles") as AnyObject[]!
        cell!.textLabel.text = titles.objectAtIndex(indexPath.row) as String
        
        var values:NSArray = self.currentAlbumData!.objectForKey("values") as AnyObject[]!
        //cell!.detailTextLabel.text = values.objectAtIndex(indexPath.row) as String
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        
    }
    
    func showDataForAlbumAtIndex(albumIndex:Int)->Void
    {
        if albumIndex < self.allAlbums!.count{
            var album = self.allAlbums![albumIndex] as Album
            self.currentAlbumData = album.tableRepresentation()
        }
        else{
            self.currentAlbumData = nil;
        }
        self.tableView.reloadData()
    }
}
