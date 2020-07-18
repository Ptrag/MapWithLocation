import Foundation
import UIKit

struct Alert {
    static func showBasicAlert(on vc: UIViewController, with title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true)
    }
    
    static func showUserLocationDisableAlert(on vc: UIViewController){
        showBasicAlert(on: vc, with: "Location Services Disabled", message: "Location services are diabled please enable them to use this app")
    }
    
    static func curentLocationNotFoundAlert(on vc: UIViewController){
        showBasicAlert(on: vc, with: "Curent location not found", message: "Unable to find curent phone location")
    }
    
    static func distanceCalulatinErrorAlert(on vc: UIViewController){
        showBasicAlert(on: vc, with: "Distance calculation error", message: "Distance calulations were unsucesfull")
    }
    
    static func markLocationError(on vc: UIViewController){
        showBasicAlert(on: vc, with: "Mark location not found", message: "Mark location can't be resolved")
    }
    
    
    
}
