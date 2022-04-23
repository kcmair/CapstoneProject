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
    
    var routeStartpoint: MKPlacemark
    var routeMidpoint: MKPlacemark
    var routeEndpoint: MKPlacemark
//    var routeRegion: String
    var cycleType: String
    var sceneryRating: Double
    var roadRating: Double
    var routeRating: Double
    var routeNotes: String?
    var routeCreatedBy: CKUserIdentity
    var ckRecordID: CKRecord.ID
    
    init(routeStartpoint: MKPlacemark,
         routeMidpoint: MKPlacemark,
         routeEndpoint: MKPlacemark,
//         routeRegion: String,
         cycleType: String,
         sceneryRating: Double,
         roadRating: Double,
         routeRating: Double,
         routeNotes: String? = "",
         routeCreatedBy: CKUserIdentity,
         ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString))
    {
        self.routeStartpoint = routeStartpoint
        self.routeMidpoint = routeMidpoint
        self.routeEndpoint = routeEndpoint
//        self.routeRegion = routeRegion
        self.cycleType = cycleType
        self.sceneryRating = sceneryRating
        self.roadRating = roadRating
        self.routeRating = routeRating
        self.routeNotes = routeNotes
        self.routeCreatedBy = routeCreatedBy
        self.ckRecordID = ckRecordID
    }
} // End of class

extension Route {
    convenience init?(ckRecord: CKRecord) {
        guard let routeStartpoint = ckRecord[CKConstants.routeStartKey] as? MKPlacemark,
              let routeMidpoint = ckRecord[CKConstants.routeMidKey] as? MKPlacemark,
              let routeEndpoint = ckRecord[CKConstants.routeEndKey] as? MKPlacemark,
//              let routeRegion = ckRecord[CKConstants.routeRegionKey] as? String,
              let cycleType = ckRecord[CKConstants.cycleTypeKey] as? String,
              let sceneryRating = ckRecord[CKConstants.sceneryRatingKey] as? Double,
              let roadRating = ckRecord[CKConstants.roadRatingKey] as? Double,
              let routeRating = ckRecord[CKConstants.routeRatingKey] as? Double,
              let routeNotes = ckRecord[CKConstants.routeNotesKey] as? String,
              let routeCreatedBy = ckRecord[CKConstants.routeCreatedByKey] as? CKUserIdentity
        else { return nil }
        
        self.init(routeStartpoint: routeStartpoint,
                  routeMidpoint: routeMidpoint,
                  routeEndpoint: routeEndpoint,
//                  routeRegion: routeRegion,
                  cycleType: cycleType,
                  sceneryRating: sceneryRating,
                  roadRating: roadRating,
                  routeRating: routeRating,
                  routeNotes: routeNotes,
                  routeCreatedBy: routeCreatedBy,
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
            CKConstants.routeStartKey : route.routeStartpoint,
            CKConstants.routeMidKey : route.routeMidpoint,
            CKConstants.routeEndKey : route.routeEndpoint,
//            CKConstants.routeRegionKey : route.routeRegion,
            CKConstants.cycleTypeKey : route.cycleType,
            CKConstants.sceneryRatingKey : route.sceneryRating,
            CKConstants.roadRatingKey : route.roadRating,
            CKConstants.routeRatingKey : route.routeRating,
            CKConstants.routeNotesKey : route.routeNotes ?? "",
            CKConstants.routeCreatedByKey : route.routeCreatedBy
        ])
    }
} // End of extension
