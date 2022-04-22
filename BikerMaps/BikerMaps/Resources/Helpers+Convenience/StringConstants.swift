//
//  Region.swift
//  BikerMaps
//
//  Created by Keith Mair on 4/19/22.
//

import Foundation

class Region {
    let northWest = "North West"
    let southWest = "South West"
    let northCentral = "North Central"
    let southCentral = "South Central"
    let northEast = "North East"
    let southEast = "South East"
} // End of class

class CycleType {
    let roadBicycle = "Road Bicycle"
    let roadMotorcycle = "Road Motorcycle"
    let mountainBike = "Mountain Bike"
    let dirtBike = "Dirt Bike"
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
