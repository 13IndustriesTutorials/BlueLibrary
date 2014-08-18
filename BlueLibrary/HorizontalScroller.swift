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
    
    func horizontalScrollerClickedViewAtIndex(scroller:HorizontalScroller, index:Int)->Void
    
    func horizontalScrollerViewAtIndex(scroller:HorizontalScroller, index:Int)->UIView!
    
    optional func initialViewIndexForHorizontalScroller(scroller:HorizontalScroller)->Int
}

class HorizontalScroller: UIView, UIScrollViewDelegate {

    let ViewPadding:CGFloat = 10
    let ViewDimensions:CGFloat = 100
    let ViewsOffset:CGFloat = 100
    
    let scrollView:UIScrollView
    
    var delegate:HorizontalScrollerDelegate?
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init(frame: CGRect) {
        //create the scroll view
        self.scrollView = UIScrollView(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))
        super.init(frame: frame)
        
        self.scrollView.delegate = self
        
        //create a tap gusture
        var tapRecognizer = UITapGestureRecognizer(target: self, action:"scrollerTapped:")
        
        //set the scroll view delegate
        scrollView.delegate = self
        
        //add the tap gestsure to the scroll view
        scrollView.addGestureRecognizer(tapRecognizer)
        
        //add scroll view to the main view
        self.addSubview(self.scrollView)
    }
    
     override func didMoveToSuperview()
    {
        self.reload()
    }
    
    func scrollerTapped(gesture:UITapGestureRecognizer)
    {
        //get the location tapped
        var location = gesture.locationInView(gesture.view)
        
        var size = self.delegate!.numberOfViewsForHorizontalScroller(self)
        
        var index:Int
        for index = 0; index < size; index++
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
    
    func reload()
    {
        if self.delegate == nil
        {
            return
        }

        //remove all subviews
        for view:AnyObject in self.scrollView.subviews
        {
            (view as UIView).removeFromSuperview()
        }

        var xValue = self.ViewsOffset
        var numberViews = self.delegate!.numberOfViewsForHorizontalScroller(self)
        
        var index:Int
        for index = 0; index < numberViews; index++
        {
            xValue += self.ViewPadding
            
            var view:UIView = self.delegate!.horizontalScrollerViewAtIndex(self, index: index)
            view.frame = CGRectMake(xValue, self.ViewPadding, self.ViewDimensions, self.ViewDimensions)
            self.scrollView.addSubview(view)
            xValue += self.ViewDimensions + self.ViewPadding
        }
        
        self.scrollView.contentSize = CGSizeMake(xValue + self.ViewsOffset, self.frame.size.height)
        
        if self.delegate!.respondsToSelector("initialViewIndexForHorizontalScroller")
        {
            let initialView = self.delegate!.initialViewIndexForHorizontalScroller!(self)
            let padding:CGFloat = (2 * self.ViewPadding) + self.ViewDimensions
            self.scrollView.contentOffset = CGPointMake(CGFloat(initialView) * padding, 0.0)
        }
    }

    func centerCurrentView()->Void
    {
        var xFinal:Int = Int(self.scrollView.contentOffset.x + (self.ViewsOffset/2 + self.ViewPadding))
        var viewIndex:Int = xFinal / Int(self.ViewDimensions + (2.0 * self.ViewPadding))
        
        xFinal = viewIndex * Int(self.ViewDimensions + (2.0 * self.ViewPadding))
        
        self.scrollView.contentOffset = CGPointMake(CGFloat(xFinal), 0)
        self.delegate!.horizontalScrollerClickedViewAtIndex(self, index: viewIndex)
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView!,willDecelerate decelerate: Bool)
    {
        if !decelerate
        {
            self.centerCurrentView()
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView!)
    {
        self.centerCurrentView()
    }
}
