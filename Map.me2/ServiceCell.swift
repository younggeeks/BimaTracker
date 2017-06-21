//
//  ServiceCell.swift
//  Map.me2
//
//  Created by Samwel Charles on 28/05/2017.
//  Copyright © 2017 younggeeks. All rights reserved.
//

import UIKit

class ServiceCell: UICollectionViewCell {
    
    @IBOutlet weak var serviceNameLbl: UILabel!
    @IBOutlet weak var serviceThumb: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5.0
    }
    
    func configureCell(service:Service){
        serviceThumb.image = UIImage(named: service.logo)
        serviceNameLbl.text = service.name
    }
}
