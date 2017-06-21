//
//  RoundedImage.swift
//  Map.me2
//
//  Created by Samwel Charles on 28/05/2017.
//  Copyright © 2017 younggeeks. All rights reserved.
//

import Foundation
import UIKit

class RoundedImage:UIImageView{
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.cornerRadius = 5.0
        self.clipsToBounds = true
    }
}
