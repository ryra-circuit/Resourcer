import UIKit
import CoreLocation
import MapKit

public protocol AppleMapsDirectionsDelegate {
    func showDirectionsOnAppleMapView(place: Place?)
}

public extension AppleMapsDirectionsDelegate {
    
    // MARK: - Open with apple maps
    func showDirectionsOnAppleMapView(place: Place?) {
        
        let userLocation: CLLocation? = CLLocation(latitude: 1.0, longitude: 1.0)
        
        guard userLocation != nil else {
            print("User location not found")
            // Show the issue here with Alert Controller
            return
        }
        
        guard place?.latitude != nil && place?.longitude != nil && place?.latitude != 0 && place?.longitude != 0 else {
            print("Destination location not found")
            // Show the issue here with Alert Controller
            return
        }
        
        let source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: userLocation?.coordinate.latitude ?? 0.0, longitude: userLocation?.coordinate.longitude ?? 0.0)))
        source.name = "Current Location"
        
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: place?.latitude ?? 0.0, longitude: place?.longitude ?? 0.0)))
        destination.name = place?.name ?? "Destination Location"
        
        MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}
