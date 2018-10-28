//
//  DetailView.swift
//  MoovUpTest
//
//  Created by Sky Wong on 24/10/2018.
//  Copyright © 2018 Sky Wong. All rights reserved.
//

import UIKit
import MapKit

class MapView: UIViewController, MKMapViewDelegate {

    var friend: FriendObject?
    
    // map view elements
    var mapView: MKMapView = MKMapView()
    let REGIONRADIUS: CLLocationDistance = 5000     // set your initial zoom resolution

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = friend?.name
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let leftMargin:CGFloat = 0
        let topMargin:CGFloat = 0
        let mapWidth:CGFloat = view.frame.size.width
        let mapHeight:CGFloat = view.frame.size.height
        
        mapView.frame = CGRect(x: leftMargin, y: topMargin, width: mapWidth, height: mapHeight)
        
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.delegate = self
        
        let initialLocation = CLLocation(latitude: friend?.location.latitude ?? 0.0, longitude: friend?.location.longitude ?? 0.0)
        //let initialLocation = CLLocation(latitude: 22.4, longitude: 114) // hong kong
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate, REGIONRADIUS, REGIONRADIUS)
        mapView.setRegion(coordinateRegion, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.title = friend?.name
        annotation.coordinate = CLLocationCoordinate2D(latitude: initialLocation.coordinate.latitude,  longitude: initialLocation.coordinate.longitude)
        mapView.addAnnotation(annotation)
        
        view.addSubview(mapView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        if let annotationTitle = view.annotation?.title
        {
            // show detail view
            let disclosureView = DisclosureView()
            disclosureView.friend = self.friend
            disclosureView.view.backgroundColor = UIColor.black.withAlphaComponent(0.5) // opaque
            disclosureView.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext // able to show the previous view
            disclosureView.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            self.present(disclosureView, animated: true, completion: nil)
        }
    }


}
