import MapKit
import CoreLocation
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let regionZoomAmount: Double = 5000
    
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
            centerLocationViewOnUser()
            locationManager.startUpdatingLocation()
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
    
    //zooming on user location
    func centerLocationViewOnUser() {
        if let location = locationManager.location?.coordinate{
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionZoomAmount, longitudinalMeters: regionZoomAmount)
            mapView.setRegion(region, animated: true)
        }
            
        
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    //updateing as user moves
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionZoomAmount, longitudinalMeters: regionZoomAmount)
        mapView.setRegion(region, animated: true)
    }
    
    //when authorization changes
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorizationState()
    }
}

