//
//  AnnotationView.swift
//  Map.me2
//
//  Created by Samwel Charles on 27/05/2017.
//  Copyright © 2017 younggeeks. All rights reserved.
//

import Foundation
import MapKit


class AnnotationView:MKAnnotationView{
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        
        if hitView != nil{
            self.superview?.bringSubview(toFront: self)
        }
        return hitView
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let rect  = self.bounds
        var isInside:Bool = rect.contains(point)
        if !isInside{
            for view in self.subviews{
                isInside = view.frame.contains(point)
                if isInside{
                    break
                }
            }
        }
        return isInside
    }
}
