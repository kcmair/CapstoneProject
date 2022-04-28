//
//  RouteDetailViewController.swift
//  BikerMaps
//
//  Created by Keith Mair on 4/27/22.
//

import UIKit
import MapKit

class RouteDetailViewController: UIViewController {
    
    // MARK: - Oulets
    @IBOutlet weak var routeNameLabel: UILabel!
    @IBOutlet weak var cycleTypeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var sceneryRatingLabel: UILabel!
    @IBOutlet weak var roadRatingLabel: UILabel!
    @IBOutlet weak var overallRatingLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    var route: Route?
    var distanceInMiles: Double = 0
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    // MARK: - Helper functions
    func updateViews() {
        if let route = route {
            routeNameLabel.text = route.routeName
            cycleTypeLabel.text = route.cycleType
            sceneryRatingLabel.text = "\(route.sceneryRating)"
            roadRatingLabel.text = "\(route.roadRating)"
            overallRatingLabel.text = "\(route.overallRating)"
            createDirectionsRequestfrom(firstCoordinate: route.routeStartpoint, secondCoordinate: route.routeMidpoint)
            createDirectionsRequestfrom(firstCoordinate: route.routeMidpoint, secondCoordinate: route.routeEndpoint)
        }
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
                self.distanceInMiles = self.distanceInMiles + ((round(route.distance * 0.00621371)) / 10)
                self.distanceLabel.text = "\(self.distanceInMiles) miles"
            }
        }
    }    
    
    // MARK: - Actions
    
} // End of class

extension RouteDetailViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .blue
        
        return renderer
    }
} // End of extension
