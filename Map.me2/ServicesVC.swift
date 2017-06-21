//
//  ServicesVC.swift
//  Map.me2
//
//  Created by Samwel Charles on 28/05/2017.
//  Copyright © 2017 younggeeks. All rights reserved.
//

import UIKit

class ServicesVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var services = [Service]()
    
    var filteredServices = [Service]()
    
    var inSearchMode:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
    }
    
    func demoServices(){
        let radiology = Service()
        radiology.logo = "radiology"
        radiology.name = "Radiology"
        
        let eye = Service()
        eye.logo = "eye"
        eye.name = "Eyes"
        
        let cardiology = Service()
        cardiology.logo = "cardiology"
        cardiology.name = "Cardiology"
        
        let dental = Service()
        dental.logo = "dental"
        dental.name = "Dental Services"
        
        let neurology = Service()
        neurology.logo = "neurology"
        neurology.name = "Neurology"
        
        let urology = Service()
        urology.logo = "urology"
        urology.name = "Urology"
        
        let orthopedic = Service()
        orthopedic.logo = "orthopedic"
        orthopedic.name = "Orthopedic"
        
        let neuralsurgery = Service()
        neuralsurgery.logo = "neuralsurgery"
        neuralsurgery.name = "Neural Surgery"

        services.append(contentsOf: [radiology,eye,cardiology,dental,neurology,urology,orthopedic,neuralsurgery])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        demoServices()
    }
}

extension ServicesVC:UICollectionViewDelegate{
    
}
extension ServicesVC:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceCell", for: indexPath) as? ServiceCell
        let service:Service!
        
        //search is pressed we take service index from filtered services array
        if inSearchMode{
            service = filteredServices[indexPath.row]
            cell?.configureCell(service: service)
        }else{
            //otherwise we fetch from normal array
            service = services[indexPath.row]
            cell?.configureCell(service: service)
        }
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode{
           return filteredServices.count
        }
        return services.count
    }
    }

extension ServicesVC:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == ""{
            inSearchMode = false
            collectionView.reloadData()
            searchBar.resignFirstResponder()
        }else{
            inSearchMode = true
            let lower = searchBar.text?.lowercased()
            filteredServices = services.filter({$0.name.range(of: lower!) != nil})
            collectionView.reloadData()
        }
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
