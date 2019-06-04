//
//  ViewController.swift
//  geoFencingApp
//
//  Created by Ghare, Manali on 6/4/19.
//  Copyright © 2019 Ghare, Manali. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import UserNotifications

class ViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager:CLLocationManager = CLLocationManager()
    
    let center = UNUserNotificationCenter.current()
    let content = UNMutableNotificationContent()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 100
        
        center.requestAuthorization(options: [.alert, .sound])
            {(granted,error) in }
        
         let geoFenceRegion:CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(35.2271,-80.8431), radius: 100, identifier: "Charlotte")
      
        content.title = "Location Update"
        content.body = "Exited \(geoFenceRegion.identifier)"
        
       
        
       
        
        locationManager.startMonitoring(for: geoFenceRegion)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        
        self.mapView.centerCoordinate = locations[0].coordinate
        let reg = MKCoordinateRegion(center: locations[0].coordinate, latitudinalMeters: 8000, longitudinalMeters: 8000)
        self.mapView.setRegion(reg, animated: true)
        self.mapView.showsUserLocation = true
        
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entered \(region.identifier)")
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exited \(region.identifier)")
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

