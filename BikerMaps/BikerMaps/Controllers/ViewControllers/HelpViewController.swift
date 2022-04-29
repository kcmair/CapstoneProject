//
//  HelpViewController.swift
//  BikerMaps
//
//  Created by Keith Mair on 4/29/22.
//

import UIKit

class HelpViewController: UIViewController {

    @IBOutlet weak var helpView: UIView!
    @IBOutlet weak var helpTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    private func updateViews() {
        helpTextLabel.text = HelpView.helpViewText
    }

}
