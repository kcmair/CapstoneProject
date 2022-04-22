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
    var route: Route?
    var directionsArray: [MKDirections] = []
    var startpointCoordinate: CLLocationCoordinate2D?
    var midpointCoordinate: CLLocationCoordinate2D?
    var endpointCoordinate: CLLocationCoordinate2D?
    
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
        if startpointCoordinate.debugDescription.isEmpty {
            startpointCoordinate = getCenterLocation(for: mapView).coordinate
            directionsLabel.text = "Please select an ending location."
            return
        }
        
        if endpointCoordinate.debugDescription.isEmpty {
            endpointCoordinate = getCenterLocation(for: mapView).coordinate
            directionsLabel.text = "Please select a midpoint location."
            return
        }
        
        if midpointCoordinate.debugDescription.isEmpty {
            midpointCoordinate = getCenterLocation(for: mapView).coordinate
            createDirectionsRequestfrom(firstCoordinate: startpointCoordinate!, secondCoordinate: midpointCoordinate!)
            createDirectionsRequestfrom(firstCoordinate: midpointCoordinate!, secondCoordinate: endpointCoordinate!)
            directionsLabel.text = "Is this the correct route?\n If so tap next."
            selectButton.configuration?.title = "Next"
            return
        }
    }
    
    func createDirectionsRequestfrom(firstCoordinate: CLLocationCoordinate2D, secondCoordinate: CLLocationCoordinate2D) {
        let firstMarker = MKPlacemark(coordinate: firstCoordinate)
        let secondMarker = MKPlacemark(coordinate: secondCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: firstMarker)
        request.destination = MKMapItem(placemark: secondMarker)
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
            
            for routeView in response.routes {
                self.mapView.addOverlay(routeView.polyline)
                self.mapView.setVisibleMapRect(routeView.polyline.boundingMapRect, animated: true)
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
