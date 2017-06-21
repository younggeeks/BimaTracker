//
//  Annotator.swift
//  Map.me2
//
//  Created by Samwel Charles on 27/05/2017.
//  Copyright © 2017 younggeeks. All rights reserved.
//

import Foundation
import MapKit
class Annotator: NSObject,MKAnnotation {
    var address: String!
    var phone: String!
    var image:UIImage!
    var name:String!
    var title: String?
    var services:String!
    var coordinate: CLLocationCoordinate2D
    
    init(coordinate:CLLocationCoordinate2D){
        self.coordinate = coordinate
    }
}
