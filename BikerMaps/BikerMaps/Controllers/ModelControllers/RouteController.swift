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
    private let geoCoder = CLGeocoder()
    
    // MARK: - Create
    func createRouteWith(routeStartpoint: CLLocationCoordinate2D,
                         routeMidpoint: CLLocationCoordinate2D,
                         routeEndpoint: CLLocationCoordinate2D,
                         routeName: String,
                         cycleType: String,
                         sceneryRating: Float,
                         roadRating: Float,
                         overallRating: Float,
                         routeNotes: String?,
                         completion: @escaping(Bool) -> Void){
        
        let startLatitude: CLLocationDegrees = routeStartpoint.latitude
        let startLongitude: CLLocationDegrees = routeStartpoint.longitude
        let endLatitude: CLLocationDegrees = routeEndpoint.latitude
        let endLongitude: CLLocationDegrees = routeEndpoint.longitude

        getLocation(locationLatitude: startLatitude, locationLongitude: startLongitude) { startLocation in
            
            self.getLocation(locationLatitude: endLatitude, locationLongitude: endLongitude) { endLocation in
                
                let newRoute = Route(routeStartpoint: routeStartpoint,
                                     routeMidpoint: routeMidpoint,
                                     routeEndpoint: routeEndpoint,
                                     routeName: routeName,
                                     cycleType: cycleType,
                                     sceneryRating: sceneryRating,
                                     roadRating: roadRating,
                                     overallRating: overallRating,
                                     routeNotes: routeNotes ?? "",
                                     startLocation: startLocation,
                                     endLocation: endLocation)
                
                self.save(route: newRoute, completion: completion)
            }
        }
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
    
    private func getLocation(locationLatitude: CLLocationDegrees, locationLongitude: CLLocationDegrees, completion: @escaping (String) -> Void){
        var locationCity = "City error 1"
        var locationState = "State error 1"
        let location: CLLocation = CLLocation(latitude: locationLatitude, longitude: locationLongitude)
        self.geoCoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion("unable to goecode")
            }
            
            guard let placemark = placemarks?.first
            else {
                print("No data for startpoint")
                return completion("no placemark")
            }
            
            locationCity = placemark.locality ?? "City error 2"
            locationState = placemark.administrativeArea ?? "State error 2"
            completion("\(locationCity), \(locationState)")
        }
    }
} // End of class
