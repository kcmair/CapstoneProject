//
//  RouteController.swift
//  BikerMaps
//
//  Created by Keith Mair on 4/19/22.
//

import Foundation
import MapKit
import CloudKit

class RouteController {
    
    // MARK: - Shared instance
    static let shared = RouteController()
    
    // MARK: - Properties
    var routes: [Route] = []
    let coordinate = CLLocationCoordinate2D()
    var publicDB = CKContainer.default().publicCloudDatabase
    
    // MARK: - Create
    func createRouteWith(routeStartpoint: MKPlacemark,
                         routeMidpoint: MKPlacemark,
                         routeEndpoint: MKPlacemark,
//                         routeRegion: String,
                         cycleType: String,
                         sceneryRating: Double,
                         roadRating: Double,
                         routeRating: Double,
                         routeNotes: String?,
                         routeCreatedBy: CKUserIdentity,
                         completion: @escaping(Bool) -> Void){
        
        let newRoute = Route(routeStartpoint: routeStartpoint,
                             routeMidpoint: routeMidpoint,
                             routeEndpoint: routeEndpoint,
//                             routeRegion: routeRegion,
                             cycleType: cycleType,
                             sceneryRating: sceneryRating,
                             roadRating: roadRating,
                             routeRating: routeRating,
                             routeNotes: routeNotes ?? "",
                             routeCreatedBy: routeCreatedBy)
        
        save(route: newRoute, completion: completion)
    }
    
    // MARK: - Save
    func save(route: Route, completion: @escaping(Bool) -> Void) {
        let entryRecord = CKRecord(route: route)
        publicDB.save(entryRecord) { record, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(false)
            }
            
            guard let record = record,
                  let savedRoute = Route(ckRecord: record)
            else { return completion(false) }
            self.routes.append(savedRoute)
            completion(true)
        }
    }
    
    // MARK: - Fetch
    func fetchRoutes(completion: @escaping(Bool) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: CKConstants.recordTypeKey, predicate: predicate)
        publicDB.perform(query, inZoneWith: nil) { records, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(false)
            }
            guard let records = records
            else { return completion(false) }
            self.routes = records.compactMap { Route(ckRecord: $0) }
            completion(true)
        }
    }
    
    // MARK: - Update
    func update(_ route: Route, completion: @escaping (Bool) -> Void) {
        let recordToUpdate = CKRecord(route: route)
        let operation = CKModifyRecordsOperation(recordsToSave: [recordToUpdate], recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { (records, _, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(false)
            }
            
            guard let record = records?.first
            else { return completion(false) }
            print("Updated \(record.recordID.recordName) successfully in CloudKit.")
            completion(true)
        }
        publicDB.add(operation)
    }
    
    // MARK: - Delete
    func delete(_ route: Route, completion: @escaping (Bool) -> Void ) {
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [route.ckRecordID])
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { (_, recordIDs, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(false)
            }
            
            guard let recordIDs = recordIDs
            else { return completion(false) }
            print("\(recordIDs) was removed successfully.")
            completion(true)
        }
        publicDB.add(operation)
    }
} // End of class
