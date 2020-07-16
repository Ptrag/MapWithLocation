import MapKit
import CoreLocation
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var destinationLabel: UIButton!
    
    let locationManager = CLLocationManager()
    let regionZoomAmount: Double = 5000
    var prevoiusLocation: CLLocation?
    var directionsArray: [MKDirections] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        destinationLabel.layer.cornerRadius = destinationLabel.frame.size.height/2
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
            prevoiusLocation = getCenterMapLocation(mapView: mapView)
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
        @unknown default:
            break
        }
    }
    
    func getDirections(){
        //check if we have user location
        guard let location = locationManager.location?.coordinate else {
            //alert that we dont have user location
            return
        }
        //creating a direction request from starting location(user location) and destination(center of the map)
        let destinationCoordinate = getCenterMapLocation(mapView: mapView).coordinate
        let startingLocation = MKPlacemark(coordinate: location)
        let destination = MKPlacemark(coordinate: destinationCoordinate)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startingLocation)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .automobile
        request.requestsAlternateRoutes = false
        
        let directions = MKDirections(request: request)
        resetMapView(directions: directions)
        
        directions.calculate { [unowned self](response, error) in
            guard let response = response else {
                //show alert to user response not avilable
                return
            }
            self.mapView.addOverlay(response.routes[0].polyline)
            self.mapView.setVisibleMapRect(response.routes[0].polyline.boundingMapRect, animated: true)
        }
    }
    
    //clearing the view form prevois destinations
    func resetMapView(directions: MKDirections){
        mapView.removeOverlays(mapView.overlays)
        directionsArray.append(directions)
        let _ = directionsArray.map { $0.cancel() }
    }
    
    @IBAction func searchPathButtonPressed(_ sender: UIButton) {
        getDirections()
    }
    
    //zooming on user location
    func centerLocationViewOnUser() {
        if let location = locationManager.location?.coordinate{
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionZoomAmount, longitudinalMeters: regionZoomAmount)
            mapView.setRegion(region, animated: true)
        }
        
    }
    
    //geting center cordinates from curent map position
    func getCenterMapLocation(mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}

extension ViewController: CLLocationManagerDelegate {
    //when authorization changes
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorizationState()
    }
}


//keeping track of the screen location on the map
extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let centerPosition = getCenterMapLocation(mapView: mapView)
        guard let previousLocation = self.prevoiusLocation else{
            return
        }
        
        //setting position change buffer for starting reverse geolacation
        guard centerPosition.distance(from: previousLocation) > 50 else {
            return
        }
        self.prevoiusLocation = centerPosition
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(centerPosition) { [weak self](placemarks, error) in
            guard let self = self else{
                return
            }
            
            //error checking
            if let _ = error {
                //show alert informing user
                return
            }
            guard let placemark = placemarks?.first else{
                //alert informing user
                return
            }
            
            let streetNumber = placemark.subThoroughfare ?? ""
            let strretName = placemark.thoroughfare ?? ""
            let cityName = placemark.locality ?? ""
            
            DispatchQueue.main.async {
                self.locationLabel.text = "\(strretName) \(streetNumber), \(cityName)"
            }
        }
    }
    
    //drawing polyline on mapview
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .blue
        return renderer
    }
}

