//
//  Region.swift
//  BikerMaps
//
//  Created by Keith Mair on 4/19/22.
//

import Foundation

struct CycleType {
    static let initialText = "Scroll to select"
    static let roadBicycle = "Street Bicycle"
    static let roadMotorcycle = "Street Motorcycle"
    static let mountainBike = "Mountain Bike"
    static let dirtBike = "Motocross/Dirt Bike"
    static let dualSport = "Dual Sport Motorcycle"
} // End of class

struct CKConstants {
    static let recordTypeKey = "Route"
    static let routeStartLatitudeKey = "routeStartLatitude"
    static let routeStartLongitudeKey = "routeStartLongitude"
    static let routeMidLatitudeKey = "routeMidLatitude"
    static let routeMidLongitudeKey = "routeMidLongitude"
    static let routeEndLatitudeKey = "routeEndLatitude"
    static let routeEndLongitudeKey = "routeEndLongitude"
    static let routeNameKey = "routeName"
    static let cycleTypeKey = "cycleType"
    static let sceneryRatingKey = "sceneryRating"
    static let roadRatingKey = "roadRating"
    static let difficultyRatingKey = "difficultyRating"
    static let overallRatingKey = "overallRating"
    static let routeNotesKey = "routeNotes"
    static let startLocationKey = "startLocation"
    static let endLocationKey = "endLocation"
    static let routeCreatedByKey = "routeCreatedBy"
} // End of struct
