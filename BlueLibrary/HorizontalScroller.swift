//
//  HorizontalScroller.swift
//  BlueLibrary
//
//  Created by user on 7/16/14.
//  Copyright (c) 2014 someCompanyNameHere. All rights reserved.
//

import UIKit

@objc protocol HorizontalScrollerDelegate: NSObjectProtocol
{
    func numberOfViewsForHorizontalScroller(scroller:HorizontalScroller)->Int
    
    func horizontalScrollerViewAtIndex(scroller:HorizontalScroller, index:Int)->UIView!
    
    @optional func initialViewIndexForHorizontalScroller(scroller:HorizontalScroller)->Int
}

class HorizontalScroller: UIView, HorizontalScrollerDelegate, UIScrollViewDelegate {

    let ViewPadding = 10
    let ViewDimensions = 100
    let ViewOffset = 100
    
    let scrollView:UIScrollView
    
    var delegate:HorizontalScrollerDelegate?
    
    init(frame: CGRect) {
        //create the scroll view
        self.scrollView = UIScrollView(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))
        super.init(frame: frame)
        
        self.delegate = self
        
        //create a tap gusture
        var tapRecognizer = UITapGestureRecognizer(target: self, action:"scrollerTapped")
        
        //set the scroll view delegate
        scrollView.delegate = self
        
        //add the tap gestsure to the scroll view
        scrollView.addGestureRecognizer(tapRecognizer)
        
        //add scroll view to the main view
        self.addSubview(self.scrollView)
    }
    
    func scrollerTapped(gesture:UITapGestureRecognizer)
    {
        //get the location tapped
        var location = gesture.locationInView(gesture.view)
        
        var size = self.delegate!.numberOfViewsForHorizontalScroller(self)
        for index in 0..size
        {
            var view = self.scrollView.subviews[index] as UIView
            
            if CGRectContainsPoint(view.frame,location)
            {
                self.delegate!.horizontalScrollerViewAtIndex(self, index: index)
                self.scrollView.setContentOffset(CGPointMake(view.frame.origin.x - self.frame.size.width/2 + view.frame.size.width/2, 0), animated: true)
                break;
            }
        }
    }
    
    func reload()->Void
    {
        
    }

    func numberOfViewsForHorizontalScroller(scroller:HorizontalScroller)->Int
    {
        return 0
    }
    
    func horizontalScrollerViewAtIndex(scroller:HorizontalScroller, index:Int)->UIView
    {
        return UIView()
    }
    
    func initialViewIndexForHorizontalScroller(scroller:HorizontalScroller)->Int
    {
        return 0
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
