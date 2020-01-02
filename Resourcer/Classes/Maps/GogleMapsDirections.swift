import UIKit
import CoreLocation
import MapKit

protocol GoogleMapsDirectionsDelegate {
    func manageGoogleMapOpeningResource(place: Place?)
    func openTrackerInBrowser(place: Place?)
}

extension GoogleMapsDirectionsDelegate {
    
    // MARK: - Check Google Maps opening resource
    func manageGoogleMapOpeningResource(place: Place?) {
        if let urlNavigation = URL.init(string: "comgooglemaps://") {
            if UIApplication.shared.canOpenURL(urlNavigation) {
                
                guard let lat = place?.latitude else {
                    return
                }
                guard let long = place?.longitude else {
                    return
                }
                
                guard let name = place?.name else {
                    return
                }
                guard let address = place?.address else {
                    return
                }
                
                // Create query with address
                let addressData = "\(name),+\(address)"
                let addressQuery = addressData.replacingOccurrences(of: " ", with: "+")
                let query = "comgooglemaps://?saddr=&daddr=\(addressQuery)&directionsmode=driving"
                
                // With Address
                if let urlDestinationWithAddress = URL.init(string: query) {
                    UIApplication.shared.open(urlDestinationWithAddress, options: [:])
                }
                    // With Lat & Long
                else if let urlDestination = URL.init(string: "comgooglemaps://?saddr=&daddr=\(lat),\(long)&directionsmode=driving") {
                    UIApplication.shared.open(urlDestination, options: [:])
                }
                    // Both failed
                else {
                    print("Location not found")
                    // Show the issue here with Alert Controller
                }
            } else {
                print("Can't use comgooglemaps://");
                self.openTrackerInBrowser(place: place)
            }
        } else {
            print("Can't use comgooglemaps://");
            self.openTrackerInBrowser(place: place)
        }
    }
    
    // MARK: - Open in web browser
    func openTrackerInBrowser(place: Place?) {
        
        guard let lat = place?.latitude else {
            return
        }
        guard let long = place?.longitude else {
            return
        }
        
        guard let name = place?.name else {
            return
        }
        guard let address = place?.address else {
            return
        }
        
        // Create query with address
        let addressData = "\(name),+\(address)"
        let addressQuery = addressData.replacingOccurrences(of: " ", with: "+")
        let query = "https://www.google.co.in/maps/dir/?saddr=&daddr=\(addressQuery)&directionsmode=driving"
        
        // With Address
        if let urlDestinationWithAddress = URL.init(string: query) {
            UIApplication.shared.open(urlDestinationWithAddress, options: [:])
        }
            // With Lat & Long
        else if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(lat),\(long)&directionsmode=driving") {
            UIApplication.shared.open(urlDestination, options: [:])
        }
            // Both failed
        else {
            print("Location not found")
            // Show the issue here with Alert Controller
        }
    }
}
