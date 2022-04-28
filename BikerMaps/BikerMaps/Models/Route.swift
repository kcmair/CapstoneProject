//
//  Map.swift
//  BikerMaps
//
//  Created by Keith Mair on 4/19/22.
//

import Foundation
import MapKit
import CloudKit

class Route {
    
    var routeStartpoint: CLLocationCoordinate2D
    var routeMidpoint: CLLocationCoordinate2D
    var routeEndpoint: CLLocationCoordinate2D
    var routeName: String
    var cycleType: String
    var sceneryRating: Float
    var roadRating: Float
    var overallRating: Float
    var routeNotes: String?
    var startLocation: String
    var endLocation: String
    var ckRecordID: CKRecord.ID
    
    init(routeStartpoint: CLLocationCoordinate2D,
         routeMidpoint: CLLocationCoordinate2D,
         routeEndpoint: CLLocationCoordinate2D,
         routeName: String,
         cycleType: String,
         sceneryRating: Float,
         roadRating: Float,
         overallRating: Float,
         routeNotes: String? = "",
         startLocation: String,
         endLocation: String,
         ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString))
    {
        self.routeStartpoint = routeStartpoint
        self.routeMidpoint = routeMidpoint
        self.routeEndpoint = routeEndpoint
        self.routeName = routeName
        self.cycleType = cycleType
        self.sceneryRating = sceneryRating
        self.roadRating = roadRating
        self.overallRating = overallRating
        self.routeNotes = routeNotes
        self.startLocation = startLocation
        self.endLocation = endLocation
        self.ckRecordID = ckRecordID
    }
} // End of class

extension Route {
    convenience init?(ckRecord: CKRecord) {
        guard let routeStartpointLatitude = ckRecord[CKConstants.routeStartLatitudeKey] as? Double,
              let routeStartpointLongitude = ckRecord[CKConstants.routeStartLongitudeKey] as? Double,
              let routeMidpointLatitude = ckRecord[CKConstants.routeMidLatitudeKey] as? Double,
              let routeMidpointLongitude = ckRecord[CKConstants.routeMidLongitudeKey] as? Double,
              let routeEndpointLatitude = ckRecord[CKConstants.routeEndLatitudeKey] as? Double,
              let routeEndpointLongitude = ckRecord[CKConstants.routeEndLongitudeKey] as? Double,
              let routeName = ckRecord[CKConstants.routeNameKey] as? String,
              let cycleType = ckRecord[CKConstants.cycleTypeKey] as? String,
              let sceneryRating = ckRecord[CKConstants.sceneryRatingKey] as? Float,
              let roadRating = ckRecord[CKConstants.roadRatingKey] as? Float,
              let overallRating = ckRecord[CKConstants.overallRatingKey] as? Float,
              let routeNotes = ckRecord[CKConstants.routeNotesKey] as? String,
              let startLocation = ckRecord[CKConstants.startLocationKey] as? String,
              let endLocation = ckRecord[CKConstants.endLocationKey] as? String
        else { return nil }
        
        self.init(routeStartpoint: CLLocationCoordinate2D(latitude: routeStartpointLatitude, longitude: routeStartpointLongitude),
                  routeMidpoint: CLLocationCoordinate2D(latitude: routeMidpointLatitude, longitude: routeMidpointLongitude),
                  routeEndpoint: CLLocationCoordinate2D(latitude: routeEndpointLatitude, longitude: routeEndpointLongitude),
                  routeName: routeName,
                  cycleType: cycleType,
                  sceneryRating: sceneryRating,
                  roadRating: roadRating,
                  overallRating: overallRating,
                  routeNotes: routeNotes,
                  startLocation: startLocation,
                  endLocation: endLocation,
                  ckRecordID: ckRecord.recordID)
    }
} // End of extension

extension Route: Equatable {
    static func == (lhs: Route, rhs: Route) -> Bool {
        return lhs.ckRecordID == rhs.ckRecordID
    }
} // End of extension


extension CKRecord {
    convenience init(route: Route) {
        self.init(recordType: CKConstants.recordTypeKey, recordID: route.ckRecordID)
        
        self.setValuesForKeys([
            CKConstants.routeStartLatitudeKey : Double(route.routeStartpoint.latitude),
            CKConstants.routeStartLongitudeKey : Double(route.routeStartpoint.longitude),
            CKConstants.routeMidLatitudeKey : Double(route.routeMidpoint.latitude),
            CKConstants.routeMidLongitudeKey : Double(route.routeMidpoint.longitude),
            CKConstants.routeEndLatitudeKey : Double(route.routeEndpoint.latitude),
            CKConstants.routeEndLongitudeKey : Double(route.routeEndpoint.longitude),
            CKConstants.routeNameKey : route.routeName,
            CKConstants.cycleTypeKey : route.cycleType,
            CKConstants.sceneryRatingKey : route.sceneryRating,
            CKConstants.roadRatingKey : route.roadRating,
            CKConstants.overallRatingKey : route.overallRating,
            CKConstants.routeNotesKey : route.routeNotes ?? "",
            CKConstants.startLocationKey : route.startLocation,
            CKConstants.endLocationKey : route.endLocation
        ])
    }
} // End of extension
