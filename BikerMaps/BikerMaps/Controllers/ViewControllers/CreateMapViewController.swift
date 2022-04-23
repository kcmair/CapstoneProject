//
//  CreateMapViewController.swift
//  BikerMaps
//
//  Created by Keith Mair on 4/21/22.
//

import UIKit
import MapKit

class CreateMapViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var directionsLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    
    // MARK: - Properties
    var directionsArray: [MKDirections] = []
    var startpointCoordinate = kCLLocationCoordinate2DInvalid
    var midpointCoordinate = kCLLocationCoordinate2DInvalid
    var endpointCoordinate = kCLLocationCoordinate2DInvalid
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Helpers
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let logitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: logitude)
    }
    
    func getSelectedLocation() {
        if !CLLocationCoordinate2DIsValid(startpointCoordinate) {
            startpointCoordinate = getCenterLocation(for: mapView).coordinate
            directionsLabel.text = "Please select an ending location."
            return
        }
        
        if !CLLocationCoordinate2DIsValid(endpointCoordinate) {
            endpointCoordinate = getCenterLocation(for: mapView).coordinate
            directionsLabel.text = "Please select a midpoint location."
            return
        }
        
        if !CLLocationCoordinate2DIsValid(midpointCoordinate) {
            midpointCoordinate = getCenterLocation(for: mapView).coordinate
            createDirectionsRequestfrom(firstCoordinate: startpointCoordinate, secondCoordinate: midpointCoordinate)
            createDirectionsRequestfrom(firstCoordinate: midpointCoordinate, secondCoordinate: endpointCoordinate)
            directionsLabel.text = "Is this the correct route?\n If so tap next."
            selectButton.configuration?.title = "Next"
            return
        }
        
        let routeCoordinates = [startpointCoordinate, midpointCoordinate, endpointCoordinate]
        performSegue(withIdentifier: "newRouteDetails", sender: routeCoordinates)
    }
    
    func createDirectionsRequestfrom(firstCoordinate: CLLocationCoordinate2D, secondCoordinate: CLLocationCoordinate2D) {
        let sourceMarker = MKPlacemark(coordinate: firstCoordinate)
        let destinationMarker = MKPlacemark(coordinate: secondCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: sourceMarker)
        request.destination = MKMapItem(placemark: destinationMarker)
        request.transportType = .automobile
        request.requestsAlternateRoutes = false
        
        drawMapUsing(request: request)
    }
    
    func drawMapUsing(request: MKDirections.Request) {
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return
            }
            
            guard let response = response
            else { return }
            
            for route in response.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
    }
    
    // MARK: - Outlets
    @IBAction func selectButtonTapped(_ sender: Any) {
        getSelectedLocation()
    }
}

extension CreateMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .blue
        
        return renderer
    }
} // End of extension
