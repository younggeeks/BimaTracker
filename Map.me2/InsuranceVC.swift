//
//  InsuranceVC.swift
//  Map.me2
//
//  Created by Samwel Charles on 28/05/2017.
//  Copyright © 2017 younggeeks. All rights reserved.
//

import UIKit

class InsuranceVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var cards = [InsuranceCard]()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCards()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func fetchCards(){
        let nhif = InsuranceCard()
        nhif.logo = UIImage(named: "NHIF")
        nhif.name = "NHIF"
        
        let aar = InsuranceCard()
        aar.logo = UIImage(named:"aaar")
        aar.name = "AAR"
        
        let nssf = InsuranceCard()
        nssf.logo = UIImage(named: "nssf")
        nssf.name = "NSSF"
        
        
        let tanesco = InsuranceCard()
        tanesco.logo = UIImage(named: "tanesco")
        tanesco.name = "Tanesco"
       
        
        
        cards.append(nssf)
        cards.append(nhif)
        cards.append(aar)
        cards.append(tanesco)
        collectionView.reloadData()
    }

}

extension InsuranceVC:UICollectionViewDelegate{
    
}
extension InsuranceVC:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cardItem = cards[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InsuranceCardCell", for: indexPath) as? InsuranceCardCell
        cell?.configureCell(card: cardItem)
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
}

extension InsuranceVC:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.2
    }
}
