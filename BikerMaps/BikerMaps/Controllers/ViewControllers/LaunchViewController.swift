//
//  ViewController.swift
//  BikerMaps
//
//  Created by Keith Mair on 4/19/22.
//

import UIKit

class LaunchViewController: UIViewController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        RouteController.shared.fetchRoutes { success in
            if success {
                print("Launchpad has loaded the data from iCloud.")
            } else {
                print("Launchpad was unable to obtaint the data from iCloud.")
            }
        }
    }
} // End of class

