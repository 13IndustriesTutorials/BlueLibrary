//
//  ViewController.swift
//  BlueLibrary
//
//  Created by user on 7/15/14.
//  Copyright (c) 2014 someCompanyNameHere. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HorizontalScrollerDelegate {

    var allAlbums:[AnyObject]?
    var currentAlbumData:NSDictionary?
    var currentAlbumIndex:Int
    @IBOutlet var tableView : UITableView?
    
    let scroller:HorizontalScroller
    var toolBar:UIToolbar
    var undostack:[AnyObject]
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        //initialize variables
        self.currentAlbumIndex = 0;
        self.scroller = HorizontalScroller(frame:CGRectMake(0,0,0,0))
        self.scroller.backgroundColor = UIColor(red: 0.76, green: 0.81, blue: 0.87, alpha: 1.0)
        self.toolBar = UIToolbar()
        self.undostack = [AnyObject]()
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.scroller = HorizontalScroller(frame: CGRectMake(0, 0, self.view.frame.size.width, 120))
        
        //configure the tool bar items
        let undoButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Undo, target: self, action: "undoAction")
        undoButton.enabled = false
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let deleteButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Trash, target: self, action: "deleteAlbum")
        self.toolBar.setItems([undoButton,space,deleteButton], animated: false)
        self.view.addSubview(self.toolBar)
        //update object and set delegate
        self.scroller.delegate = self
        self.view.frame = CGRectMake(0, 120, self.view.frame.size.width, self.view.frame.size.height)
        self.view.addSubview(scroller);
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        self.view.backgroundColor = UIColor(red: 0.76, green: 0.81, blue: 0.87, alpha: 1.0)
        self.allAlbums = LibraryAPI.sharedInstance.getAlbums()
        self.previousState()
        self.reloadScroller()
        self.showDataForAlbumAtIndex(self.currentAlbumIndex)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "saveCurrentState", name: UIApplicationDidEnterBackgroundNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillLayoutSubviews()
    {
        super.viewWillLayoutSubviews()
        self.toolBar.frame = CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 44)
        self.tableView!.frame = CGRectMake(0, 130, self.view.frame.size.width, self.view.frame.height - 200)
    }
    
    
    //tableview delegate methods
    func tableView(tableView: UITableView!,numberOfRowsInSection section: Int) -> Int
    {
        return (self.currentAlbumData!.objectForKey("titles") as [AnyObject]).count
    }
    
    func tableView(tableView: UITableView!,cellForRowAtIndexPath indexPath: NSIndexPath!) ->UITableViewCell!
    {
        let cellIdentifier = "cellIdentifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        
        if cell == nil {
            
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellIdentifier)
        }
        
        var titles:NSArray = self.currentAlbumData!.objectForKey("titles") as [AnyObject]!
        cell!.textLabel.text = titles.objectAtIndex(indexPath.row) as String
        
        var values:NSArray = self.currentAlbumData!.objectForKey("values") as [AnyObject]!
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
    
    func initialViewIndexForHorizontalScroller(scroller: HorizontalScroller) -> Int
    {
        return self.currentAlbumIndex
    }
    
    func reloadScroller()
    {
        self.allAlbums = LibraryAPI.sharedInstance.getAlbums()
        
        if self.currentAlbumIndex < 0
        {
            self.currentAlbumIndex = 0;
        }
        else if self.currentAlbumIndex >= self.allAlbums!.count
        {
            self.currentAlbumIndex = allAlbums!.count-1;
        }
        
        self.scroller.reload()
        self.showDataForAlbumAtIndex(currentAlbumIndex)
    
    }
    
    //custom methods
    
    func addAlbumAtIndex(album:Album, index:Int)
    {
        LibraryAPI.sharedInstance.addAlbum(album, index: index)
        self.currentAlbumIndex = index
        self.reloadScroller()
    }
    
    func deleteAlbum()
    {
        var deletedAlbum:Album = self.allAlbums![currentAlbumIndex] as Album
        //var sig = self.methodSignatureForSelector("addAlbumAtIndex")
        
        var undoAction = self.methodSignatureForSelector("addAlbumAtIndex")
        
        //NSInvocationOperation(target: self, selector: "addAlbumAtIndex", object: nil)
        println("\(undoAction)")
        undostack.append(undoAction)
        println("\(self.undostack)")
        LibraryAPI.sharedInstance.deleteAlbumAtIndex(currentAlbumIndex)
        self.reloadScroller()
        var item:UIBarButtonItem = self.toolBar.items![0] as UIBarButtonItem
        item.enabled = true

    }
    
    func undoAction()
    {
        if undostack.count > 0
        {
            //get operation from the stack
            //WE NEED TO FIX THIS LINE
            var operation = self.undostack[self.undostack.count-1] as NSInvocationOperation
            operation.invocation.invoke() //call the action
            self.undostack.removeLast() //remove the action
        }
        
        if undostack.count == 0
        {
            var item:UIBarButtonItem = self.toolBar.items![0] as UIBarButtonItem
            item.enabled = false
        }
    }
    
    func showDataForAlbumAtIndex(albumIndex:Int)->Void
    {
        if albumIndex < self.allAlbums!.count{
            var album = self.allAlbums![albumIndex] as Album
            self.currentAlbumData = album.tableRepresentation() as NSDictionary
        }
        else{
            self.currentAlbumData = nil;
        }
        self.tableView!.reloadData()
    }
    
    func saveCurrentState()
    {
        NSUserDefaults.standardUserDefaults().setInteger(currentAlbumIndex, forKey: "currentAlbumIndex");
        LibraryAPI.sharedInstance.saveAlbums()
    }
    
    func previousState()
    {
        self.currentAlbumIndex = NSUserDefaults.standardUserDefaults().integerForKey("currentAlbumIndex")
        self.showDataForAlbumAtIndex(self.currentAlbumIndex)
    }
}
