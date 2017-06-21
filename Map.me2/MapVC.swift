//
//  ViewController.swift
//  Map.me2
//
//  Created by Samwel Charles on 27/05/2017.
//  Copyright © 2017 younggeeks. All rights reserved.
//

import UIKit
import MapKit
import Material 
import Firebase

class MapVC: UIViewController {
    
     fileprivate var card: PresenterCard!
    /// Conent area.
    fileprivate var presenterView: UIImageView!
    fileprivate var contentView: UILabel!
    
    /// Bottom Bar views.
    fileprivate var bottomBar: Bar!
    fileprivate var dateFormatter: DateFormatter!
    fileprivate var dateLabel: UILabel!
    fileprivate var favoriteButton: IconButton!
    fileprivate var shareButton: IconButton!
    
    
    /// Toolbar views.
    fileprivate var toolbar: Toolbar!
    fileprivate var moreButton: IconButton!
    
    var locationName:String!
    var locationAddress:String!
    var locationPhone:String!
    var services:String?
    var locationImageName:UIImage!
    var currentLocation:CLLocation!
    var currentAnnotator:Annotator!
    
    

    @IBOutlet weak var mapView: MKMapView!
    
    var alert:UIAlertController!
    var locationManager = CLLocationManager()
    
    var geoFire:GeoFire!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        
        let geoFireRef = FIRDatabase.database().reference()
        geoFire = GeoFire(firebaseRef: geoFireRef)
        setLocationManager()
        
       
        checkAuth()
//        showMap()
        
       saveSample()
    }

    
    func saveSample(){
    
        let geoFireRef = FIRDatabase.database().reference()
         let hospLocation1 = CLLocation(latitude:  -6.89928675372795 , longitude:39.1614720225699 )
        
//        let hospLocation1 = CLLocation(latitude: -6.791354, longitude:39.2010428)
        
        let hospLocation2 = CLLocation(latitude:  -6.88928675372795 , longitude:39.2614720225699 )
        
        let hospLocation3 = CLLocation(latitude:  -6.88928675372795 , longitude:39.1314720225699 )
        
        let hospitalRef1 = geoFireRef.child("hospitals").child("muddyChips")
        
        let hospitalRef2 = geoFireRef.child("hospitals").child("dullaMishkakiCenter")
        
        let hospitalRef3 = geoFireRef.child("hospitals").child("MpembaCorner")
        
        let hospitalRef4 = geoFireRef.child("hospitals").child("sample4")
        
        hospitalRef1.setValue(["address":"Gomz Nature","phone":"0990859057934","name":"Muddy Chips","title":"Muddy Chips","key":"muddyChips"])
        hospitalRef2.setValue(["address":"Gongo la Mboto, Mazizini","phone":"0990859057934","name":"Just New  Hospital","title":"New Hosp","key":"dullaMishkakiCenter"])
        hospitalRef3.setValue(["address":"Magogoni","phone":"0990859057934","name":"Mpemba Chips Corner","title":"mpembaCorner","key":"MpembaCorner"])
        
        hospitalRef4.setValue(["address":"Noma, Dar es salaam","phone":"0990859057934","name":"Just New  Hospital","title":"New Hosp","key":"sample4"])
        
         GeoFire(firebaseRef:geoFireRef.child("locations")).setLocation(hospLocation1, forKey: "muddyChips")
         GeoFire(firebaseRef:geoFireRef.child("locations")).setLocation(hospLocation2, forKey: "dullaMishkakiCenter")
         GeoFire(firebaseRef:geoFireRef.child("locations")).setLocation(hospLocation3, forKey: "MpembaCorner")
        
        
        
     
       
    }
    
    func retrieveSample(){
        
        
        
//        let locs = [CLLocation]()
        
        let geoFireRef = FIRDatabase.database().reference().child("locations")
        
        let hospitalREf = FIRDatabase.database().reference().child("hospitals")
        
        let geoFire = GeoFire(firebaseRef: geoFireRef)
//        let hospLocation = CLLocation(latitude: -6.796354, longitude:39.2010428)
        
        let circeQuery = geoFire?.query(at: currentLocation, withRadius: 9.9)
        
        var handler = circeQuery?.observe(.keyEntered, with: { (key:String!,locatin:CLLocation!) in
            let hospitlQuery = hospitalREf.queryOrdered(byChild: "key").queryEqual(toValue: key)
            
            hospitlQuery.observeSingleEvent(of: .value, with: { (snapshot:FIRDataSnapshot) in
                
                let hospitalDict = snapshot.value as! [String:AnyObject]
                let locato = Annotator(coordinate: locatin.coordinate)
                let hosp = hospitalDict[key] as? [String:String]
                locato.address = hosp?["address"]!
                locato.name = hosp?["name"]!
                locato.phone = hosp?["phone"]!
                locato.title = hosp?["title"]!
                
                print("We've found location \(locato.name)")
                
                self.mapView.addAnnotation(locato)
                
                
            })
//            
//            hospitlQuery.observeSingleEvent(of: .childChanged, with: { (snapshot:FIRDataSnapshot) in
//                
//                let hospitalDict = snapshot.value as! [String:AnyObject]
//                let locato = Annotator(coordinate: locatin.coordinate)
//                let hosp = hospitalDict[key] as? [String:String]
//                locato.address = hosp?["address"]!
//                locato.name = hosp?["name"]!
//                locato.phone = hosp?["phone"]!
//                locato.title = hosp?["title"]!
//                
//                self.mapView.addAnnotation(locato)
//                
//                
//            })

            
        })
    }

    func setLocationManager(){
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
    }
    
    func checkAuth(){
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways,.authorizedWhenInUse:
            locationManager.requestLocation()
        case.denied,.restricted:
//            showAlert(msg: "Please Allow Location For Us To show you Nearest Hospitals",title:"Location Access Denied")
            print("Forever more , you need to enable Location")
        default:
            
//            showAlert(msg: "Unknown Error Occured", title: "Terible Error")
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func showAlert(msg:String,title:String){
        
        print("We'be Showing alert \(title) with message \(msg)")
        alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        
        alert.addAction(okayAction)
        
        MapVC().present(alert,animated: true)
        
    }
    func showMap(location:CLLocation){
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapView.mapType = .hybrid
        
//        let coordinate = CLLocationCoordinate2D(latitude: -6.792354, longitude: 39.208328)
//        
//        let loc2 = CLLocationCoordinate2D(latitude: -6.792854, longitude: 39.208328)
//        
//        let loc3 = CLLocationCoordinate2D(latitude: -6.792954, longitude: 39.207328)
//        
//        let anno1 = Annotator( coordinate: loc2)
//        anno1.address = "Magomeni, Kagera"
//        anno1.phone = "08187498732823"
//        anno1.name = "New Hospital"
//        anno1.title = "New Hospital"
//        anno1.image = UIImage(named: "sanitas")
//        
//        let anno2 = Annotator(coordinate:loc3)
//        anno2.name = "Rabininsia Memorial Hospital"
//        anno2.address = "Tegeta, Dar es salaam"
//        anno2.image = UIImage(named: "rabin")
//        anno2.title = "Rabininsia Memorial Hospital"
//        anno2.phone = "90329749234324"
//        anno2.services = "MRI,PHYSIOTHERAPY,CT SCAN"
//        mapView.addAnnotation(anno1)
//        mapView.addAnnotation(anno2)
        //setting Camera
//        let camera = MKMapCamera(lookingAtCenter: coordinate, fromDistance: 1500, pitch: 30, heading: 0)
//        mapView.camera = camera
        let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000)
        mapView.setRegion(region, animated: true)
    }
}

extension MapVC:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first
        
        print("Current Location\n  Latitude :  \(currentLocation.coordinate.latitude) \nLongitude \(currentLocation.coordinate.longitude)  ")
        showMap(location: locations.first!)
        retrieveSample()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("an Error Occured \(error)")
    }
}
extension MapVC:MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        return renderer
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "Pin")
        if annotationView == nil{
            annotationView = AnnotationView(annotation:annotation,reuseIdentifier:"Pin")
            annotationView?.canShowCallout = false
        }else{
            annotationView?.annotation = annotation
        }
        annotationView?.image = UIImage(named:"hospital")
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is MKUserLocation{
            return
        }
        
       let myAnnotation = view.annotation as! Annotator
        
        currentAnnotator = myAnnotation
        
        locationName = myAnnotation.name
        locationAddress = myAnnotation.address
        locationPhone = myAnnotation.phone
        locationImageName = myAnnotation.image
        services = myAnnotation.services
//        showDirection(destionation: myAnnotation.coordinate)
        cardPresenter()
        view.addSubview(card)
        mapView.setCenter((view.annotation?.coordinate)!, animated: true)
        
        
    }
    
    func callPhoneNumber(sender:UIButton){
        print("Calling \(locationPhone)")
        if let url = URL(string: "tel://\(locationPhone!)"),UIApplication.shared.canOpenURL(url){
            UIApplication.shared.canOpenURL(url)
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.isKind(of: AnnotationView.self){
            for subview in view.subviews{
                subview.removeFromSuperview()
            }
        }
    }
}


extension MapVC {
   
    func showDirection(destionation:CLLocationCoordinate2D){
        if currentLocation != nil{
            let currentMark = MKPlacemark(coordinate: currentLocation.coordinate)
            let destinationMark = MKPlacemark(coordinate: destionation)
            
            let sourceMapItem = MKMapItem(placemark: currentMark)
            let destinationMapItem = MKMapItem(placemark: destinationMark)
            
            let request = MKDirectionsRequest()
            request.source = sourceMapItem
            request.destination = destinationMapItem
            request.requestsAlternateRoutes = true
            request.transportType = .automobile
            
            let directions = MKDirections(request: request)
            
            directions.calculate(completionHandler: { (response,error) in
                guard let response = response else{
                    if let error = error{
                        print("Error \(error)")
                    }
                    return
                }
                let route = response.routes[0]
                self.mapView.add((route.polyline),level:MKOverlayLevel.aboveRoads)
                let rect = route.polyline.boundingMapRect
                self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
            })
          
          
        }
    }
    
    fileprivate func preparePresenterView() {
        presenterView = UIImageView()
        presenterView.image = locationImageName?.resize(toWidth: view.width)
        presenterView.contentMode = .scaleAspectFill
    }
    
    fileprivate func prepareDateFormatter() {
        dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
    }
    fileprivate func prepareDateLabel() {
        dateLabel = UILabel()
        dateLabel.font = RobotoFont.regular(with: 12)
        dateLabel.textColor = Color.blueGrey.base
        dateLabel.textAlignment = .center
        dateLabel.text = dateFormatter.string(from: Date.distantFuture)
    }
    
    fileprivate func prepareFavoriteButton() {
        favoriteButton = IconButton(image: Icon.phone, tintColor: Color.red.base)
        favoriteButton.addTarget(self, action: #selector(callPhoneNumber(sender:)), for: .touchUpInside)
    }
    
    fileprivate func prepareShareButton() {
        shareButton = IconButton(image: Icon.work, tintColor: Color.blueGrey.base)
        shareButton.addTarget(self, action: #selector(showLocation), for: .touchUpInside)
    }
    
    fileprivate func prepareMoreButton() {
        moreButton = IconButton(image: Icon.cm.moreHorizontal, tintColor: Color.blueGrey.base)
    }
    
    fileprivate func prepareToolbar() {
        toolbar = Toolbar(rightViews: [moreButton])
        
        toolbar.title = locationName
        toolbar.titleLabel.textAlignment = .left
        
        toolbar.detail = locationAddress
        toolbar.detailLabel.textAlignment = .left
        toolbar.detailLabel.textColor = Color.blueGrey.base
    }
    
    fileprivate func prepareContentView() {
        contentView = UILabel()
        contentView.numberOfLines = 0
        contentView.text = "Services:\(services ?? "ORTHOPEDIC") \nInsurance Cards Accepted: NHIF,AAR,TANESCO"
        contentView.font = RobotoFont.regular(with: 14)
    }
    
    fileprivate func prepareBottomBar() {
        bottomBar = Bar(leftViews: [favoriteButton], rightViews: [shareButton], centerViews: [dateLabel])
    }
    
    fileprivate func preparePresenterCard() {
        card = PresenterCard()
        
        card.toolbar = toolbar
        card.toolbarEdgeInsetsPreset = .wideRectangle2
        
        card.presenterView = presenterView
        
        card.contentView = contentView
        card.contentViewEdgeInsetsPreset = .square3
        
        card.bottomBar = bottomBar
        card.bottomBarEdgeInsetsPreset = .wideRectangle2
        
        view.layout(card).horizontally(left: 20, right: 20).center()
    }
    func cardPresenter(){
        
        preparePresenterView()
        prepareDateFormatter()
        prepareDateLabel()
        prepareFavoriteButton()
        prepareShareButton()
        prepareMoreButton()
         prepareToolbar()
        prepareContentView()
        prepareBottomBar()
        preparePresenterCard()
    }
}

extension MapVC{
    func showLocation(){
        performSegue(withIdentifier: "DetailsVC", sender: currentAnnotator)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailsVC{
            if let location = sender as? Annotator{
                destination.location = location
            }
        }
    }
}



