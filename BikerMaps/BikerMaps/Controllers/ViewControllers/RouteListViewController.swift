//
//  RouteListViewController.swift
//  BikerMaps
//
//  Created by Keith Mair on 4/26/22.
//

import UIKit

class RouteListViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableview: UITableView!
    
    // MARK: - Properties
    var routes: [Route] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRouteDetails" {
            guard let indexPath = tableview.indexPathForSelectedRow,
                  let destination = segue.destination as? RouteDetailViewController
            else { return }
            let route = RouteController.shared.routes[indexPath.row]
            destination.route = route
        }
    }

} // End of class

extension RouteListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RouteController.shared.routes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "routeTable", for: indexPath) as? RouteTableViewCell
        else { return UITableViewCell() }
        
        cell.setLocations(indexPath: indexPath)
        
        return cell
    }
} // End of extension
