//
//  ViewController.swift
//  Food Truck Tracker
//
//  Created by Prabhu Swaminathan on 01/05/17.
//  Copyright © 2017 Drivebook. All rights reserved.
//

import UIKit
import Foundation
import GoogleMaps

class MainViewController: UIViewController {

    var mapView: GMSMapView?
    var truckPosition : Array<GMSMarker>?
    var markerIcon: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        truckPosition = Array()
        markerIcon = UIImage (named: "marker")?.imageResize(sizeChange: CGSize(width: 20, height: 20))
        ConnectionManager.sharedInstance.startFoodTruckLocationUpdate(callback: {(result: Array<NSDictionary>?, error: Error?) in
            print("Result : \(self)")
            if(result != nil) {
                self.updateMarkers(result: result)
            } else {
                print("Error in fetching location of food truck: \(error)")
            }
        })
    }
    
    func updateMarkers(result : Array<NSDictionary>?) {
        var updates = [Bool?](repeating: false, count: truckPosition!.count)
        for truck in result! {
            let namePredicate = NSPredicate(format: "userData == '" + (truck.object(forKey: "id") as! String) + "'");
            let filteredArray = truckPosition?.filter { namePredicate.evaluate(with: $0) };
            if(filteredArray?.count == 0) {
                let marker = createMarker(truck:truck)
                truckPosition?.append(marker)
                updates.append(true)
            } else {
                let marker = filteredArray?[0]
                marker?.position = CLLocationCoordinate2D(latitude: truck.object(forKey: "latitude") as! Double, longitude: truck.object(forKey: "longitude") as! Double)
                let pos = truckPosition?.index(of: marker!)
                updates[pos!] = true
            }
        }
        //Remove from truckPositions for which we did not get any updates
        for i in truckPosition!.count - 1...0 {
            if(!updates[i]!) {
                truckPosition?.remove(at: i)
            }
        }
        
    }
    
    func createMarker(truck: NSDictionary) -> GMSMarker {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: truck.object(forKey: "latitude") as! Double, longitude: truck.object(forKey: "longitude") as! Double)
        if(mapView == nil) {
            createMap(position: marker.position)
        }
        marker.map = mapView
        marker.icon = markerIcon
        marker.userData = truck.object(forKey: "id")
        return marker
    }
    
    func createMap(position: CLLocationCoordinate2D) {
        let camera = GMSCameraPosition.camera(withLatitude: position.latitude, longitude: position.longitude, zoom: 9.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

