//
//  ViewController.swift
//  MapLocationDestination
//
//  Created by Pj on 15/07/2020.
//  Copyright © 2020 Pj. All rights reserved.
//
import MapKit
import CoreLocation
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        
    }
    
    //check if location services are enbled
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            checkLocationAuthorizationState()
        }else{
            //show alert to user leting them know that location services are disabled
        }
    }
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    //checking location services authorization status
    func checkLocationAuthorizationState()  {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            
            break
        case .authorizedAlways:
            
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            //alert knowing about this status
            break
        case .denied:
            //show alert about this status
            break
        default:
            print("test")
        }
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    
    //updateing as user moves
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    //when authorization changes
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
}

