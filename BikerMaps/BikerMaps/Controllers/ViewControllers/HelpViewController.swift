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
        if let url = Bundle.main.url(forResource: "BikerMapsHelp", withExtension: "rtf") {
            let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtf]
            let rtfString = try? NSMutableAttributedString(url: url, options: options, documentAttributes: nil)
            helpTextLabel.numberOfLines = 0
            helpTextLabel.lineBreakMode = .byWordWrapping
            helpTextLabel.attributedText = rtfString
        }
    }
} // End of class
