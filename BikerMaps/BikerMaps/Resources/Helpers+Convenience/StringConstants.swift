//
//  Region.swift
//  BikerMaps
//
//  Created by Keith Mair on 4/19/22.
//

import Foundation

struct Region {
    static let northWest = "North West"
    static let southWest = "South West"
    static let northCentral = "North Central"
    static let southCentral = "South Central"
    static let northEast = "North East"
    static let southEast = "South East"
} // End of class

struct CycleType {
    static let roadBicycle = "Road Bicycle"
    static let roadMotorcycle = "Road Motorcycle"
    static let mountainBike = "Mountain Bike"
    static let dirtBike = "Motocross/Dirt Bike"
    static let dualSport = "Dual Sport Motorcycle"
} // End of class

struct CKConstants {
    static let recordTypeKey = "Route"
    static let routeStartKey = "routeStartpoint"
    static let routeMidKey = "routeMidpoint"
    static let routeEndKey = "routeEndpoint"
    static let routeRegionKey = "routeRegion"
    static let cycleTypeKey = "cycleType"
    static let sceneryRatingKey = "sceneryRating"
    static let roadRatingKey = "roadRating"
    static let routeRatingKey = "routeRating"
    static let routeNotesKey = "routeNotes"
    static let routeCreatedByKey = "routeCreatedBy"
} // End of struct
