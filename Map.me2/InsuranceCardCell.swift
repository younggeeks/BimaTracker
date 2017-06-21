//
//  InsuranceCardCell.swift
//  Map.me2
//
//  Created by Samwel Charles on 28/05/2017.
//  Copyright © 2017 younggeeks. All rights reserved.
//

import UIKit

class InsuranceCardCell: UICollectionViewCell {
    @IBOutlet weak var cardThumb: UIImageView!
   
    @IBOutlet weak var cardName: UILabel!
    
    
    func configureCell(card:InsuranceCard){
        cardThumb.image = card.logo
        cardName.text = card.name
    }
}
