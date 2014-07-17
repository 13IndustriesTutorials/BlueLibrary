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

    let ViewPadding:Float = 10
    let ViewDimensions:Float = 100
    let ViewsOffset:Float = 100
    
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
        if self.delegate? == nil
        {
            return
        }
        
        for view in self.scrollView.subviews as UIView[]!
        {
            view.removeFromSuperview()
        }
        
        var xValue = self.ViewsOffset
        
        var numberViews = self.delegate!.numberOfViewsForHorizontalScroller(self)
        
        for index in 0..numberViews
        {
            xValue += self.ViewPadding
            var view = self.scrollView.subviews[index] as UIView
            view.frame = CGRectMake(xValue, self.ViewPadding, self.ViewDimensions, self.ViewDimensions)
            self.scrollView.addSubview(view)
            xValue += self.ViewDimensions + self.ViewPadding
        }
        
    
        self.scrollView.contentSize = CGSizeMake(xValue+self.ViewsOffset, self.frame.size.height)
        
        if self.delegate!.respondsToSelector("initialViewIndexForHorizontalScroller")
        {
            var initialView:Int = self.delegate!.initialViewIndexForHorizontalScroller!(self)
            var size:Float = 2 * self.ViewPadding
            var result:Float = 3 * size
            self.scrollView.contentOffset = CGPointMake(result, 0)
            
        }
        
    }

    func numberOfViewsForHorizontalScroller(scroller:HorizontalScroller)->Int
    {
        return self.scrollView.subviews.count
    }
    
    func horizontalScrollerViewAtIndex(scroller:HorizontalScroller, index:Int)->UIView
    {
        return self.scrollView.subviews[index] as UIView
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
