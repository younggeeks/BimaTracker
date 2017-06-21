//
//  DetailsVC.swift
//  Map.me2
//
//  Created by Samwel Charles on 28/05/2017.
//  Copyright © 2017 younggeeks. All rights reserved.
//

import UIKit
import Segmentio

class DetailsVC: UIViewController {

    @IBOutlet weak var segmentioView: Segmentio!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var bgImage: UIImageView!
    var location:Annotator!
    
    @IBOutlet weak var mainContainerView: UIScrollView!
        override func viewDidLoad() {
        super.viewDidLoad()
    
        setupSegmentio()
        updateView()

    }
    
    func setupSegmentio(){
        segmentioView.selectedSegmentioIndex = 0
    
        var content = [SegmentioItem]()
        
        let cards = SegmentioItem(title: "Bima", image: UIImage(named: "insurancecardicon"))
        
        let contact = SegmentioItem(title: "contact", image: UIImage(named: "insurancecardicon"))
        
        let services = SegmentioItem(title: "Services", image: UIImage(named: "insurancecardicon"))
        content.append(cards)
        content.append(services)
        content.append(contact)
        segmentioView.setup(
            content:content,
            style:SegmentioStyle.imageOverLabel,
            options:nil
        )
        
        segmentioView.valueDidChange = { segmentio,segmentIndex in
            self.updateView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        nameLbl.text = location.name
        addressLbl.text = location.address
//        bgImage.image = location.image
    }

    @IBAction func goBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate lazy var insuranceVC:InsuranceVC = {
        
        //load storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        //instantiate viewController
        var viewController = storyboard.instantiateViewController(withIdentifier: "InsuranceVC") as! InsuranceVC
        
        //add view controller as childview
        self.add(asChildViewController:viewController)
        
        return viewController
    }()
    
    fileprivate lazy var servicesVC:ServicesVC = {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        
        //instantiate ViewController 
        var viewController = storyboard.instantiateViewController(withIdentifier: "ServicesVC") as! ServicesVC
        
        //adding vc as Childview
        self.add(asChildViewController:viewController)
        
        return viewController
    }()
    
    fileprivate lazy var contactVC:ContactVC = {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        //instantiate view controller
        let viewController = storyboard.instantiateViewController(withIdentifier: "ContactVC") as! ContactVC
        
        //adding Childview
        self.add(asChildViewController: viewController)
        
        return viewController
    }()

}
extension DetailsVC{
    
    fileprivate func add(asChildViewController viewController:UIViewController){
        
        
        //add View  Controller
       addChildViewController(viewController)
        
        //adding it as Sub View 
        mainContainerView.addSubview(viewController.view)
        
        //configure childview
        viewController.view.frame = mainContainerView.bounds
//        viewController.view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
        
        //notify childviewController
        viewController.didMove(toParentViewController: self)
        
    }
    fileprivate func remove(asChildViewController viewController:UIViewController){
        
        //notify ChildView 
        viewController.willMove(toParentViewController: nil)
        
        //removing childview from superview
        viewController.view.removeFromSuperview()
        
        //notify childview controller
        viewController.removeFromParentViewController()
    }
    
    
    func updateView(){
        if segmentioView.selectedSegmentioIndex == 0{
            remove(asChildViewController: contactVC)
            remove(asChildViewController: servicesVC)
            add(asChildViewController: insuranceVC)
        }else if segmentioView.selectedSegmentioIndex == 1 {
            remove(asChildViewController: contactVC)
            remove(asChildViewController: insuranceVC)
            add(asChildViewController: servicesVC)
        }else if segmentioView.selectedSegmentioIndex == 2{
            remove(asChildViewController: servicesVC)
            remove(asChildViewController: insuranceVC)
            add(asChildViewController: contactVC)
        }else{
            fatalError("Something Went Wrong With Indexing")
        }
    }
   }
