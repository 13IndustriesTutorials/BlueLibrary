//
//  ViewController.swift
//  BlueLibrary
//
//  Created by user on 7/15/14.
//  Copyright (c) 2014 someCompanyNameHere. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, HorizontalScrollerDelegate {

    var allAlbums:AnyObject[]?
    var currentAlbumData:NSDictionary?
    var currentAlbumIndex:Int
    @IBOutlet var tableView : UITableView
    let scroller:HorizontalScroller
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        //initialize variables
        self.currentAlbumIndex = 0;
        self.scroller = HorizontalScroller(frame: CGRectMake(0, 0, 0, 0))
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        //update object and set delegate
        self.scroller.delegate = self
        self.view.frame = CGRectMake(0, 120, self.view.frame.size.width, self.view.frame.size.height)
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
    
    
    //tableview delegate methods
    func tableView(tableView: UITableView!,numberOfRowsInSection section: Int) -> Int
    {
        return (self.currentAlbumData!.objectForKey("titles") as AnyObject[]).count
    }
    
    func tableView(tableView: UITableView!,cellForRowAtIndexPath indexPath: NSIndexPath!) ->UITableViewCell!
    {
        let cellIdentifier = "cellIdentifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        
        if !cell{
            
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellIdentifier)
        }
        
        var titles:NSArray = self.currentAlbumData!.objectForKey("titles") as AnyObject[]!
        cell!.textLabel.text = titles.objectAtIndex(indexPath.row) as String
        
        var values:NSArray = self.currentAlbumData!.objectForKey("values") as AnyObject[]!
        cell!.detailTextLabel.text = values.objectAtIndex(indexPath.row) as String
        
        return cell
    }

    
    //HorizontalScroller Delegate methods
    func horizontalScrollerClickedViewAtIndex(scroller:HorizontalScroller, index:Int)->Void
    {
        self.currentAlbumIndex = index
        self.showDataForAlbumAtIndex(index)
    }
    
    func numberOfViewsForHorizontalScroller(scroller:HorizontalScroller)->Int
    {
        return self.allAlbums!.count
    }
    
    func horizontalScrollerViewAtIndex(scroller:HorizontalScroller, index:Int)->UIView!
    {
        var album:Album = self.allAlbums![index] as Album
        return AlbumView(frame: CGRectMake(0, 0, 100, 100), albumCover:album.coverUrl!)
    }
    
    //custom methods
    func showDataForAlbumAtIndex(albumIndex:Int)->Void
    {
        if albumIndex < self.allAlbums!.count{
            var album = self.allAlbums![albumIndex] as Album
            self.currentAlbumData = album.tableRepresentation() as NSDictionary
        }
        else{
            self.currentAlbumData = nil;
        }
        self.tableView.reloadData()
    }
}
