//
//  RouteTableViewCell.swift
//  BikerMaps
//
//  Created by Keith Mair on 4/27/22.
//

import UIKit

class RouteTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var startpointLabel: UILabel!
    @IBOutlet weak var endpointLabel: UILabel!
    
    // MARK: - Helper Functions
    func setLocations(indexPath: IndexPath) {
        startpointLabel.text = RouteController.shared.routes[indexPath.row].startLocation
        endpointLabel.text = RouteController.shared.routes[indexPath.row].endLocation
    }
} // End of class
