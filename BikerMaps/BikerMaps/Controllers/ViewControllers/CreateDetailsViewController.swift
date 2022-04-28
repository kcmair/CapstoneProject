//
//  CreateDetailsViewController.swift
//  BikerMaps
//
//  Created by Keith Mair on 4/22/22.
//

import UIKit
import CloudKit

class CreateDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var routeNameTextField: UITextField!
    @IBOutlet weak var cyclePicker: UIPickerView!
    @IBOutlet var sceneryRatingCollection: [UIButton]!
    @IBOutlet var roadRatingCollection: [UIButton]!
    @IBOutlet var overallRatingCollection: [UIButton]!
    @IBOutlet weak var notesTextView: UITextView!
    
    // MARK: - Properties
    var route: Route?
    let cycleTypes = ["Scroll to select", CycleType.roadBicycle, CycleType.roadMotorcycle, CycleType.mountainBike, CycleType.dirtBike, CycleType.dualSport]
    let routeCoordinates = CreateMapViewController.routeCoordinates
    var selectedCycleType: String?
    var sceneryRating = 0 {
        didSet {
            for starButton in sceneryRatingCollection {
                let imageName = (starButton.tag < sceneryRating ? "star.fill" : "star")
                starButton.setImage(UIImage(systemName: imageName), for: .normal)
                starButton.tintColor = (starButton.tag < sceneryRating ? .systemYellow : .systemBlue)
            }
            print(">> new scenery rating \(sceneryRating)")
        }
    }
    var roadRating = 0 {
        didSet {
            for starButton in roadRatingCollection {
                let imageName = (starButton.tag < roadRating ? "star.fill" : "star")
                starButton.setImage(UIImage(systemName: imageName), for: .normal)
                starButton.tintColor = (starButton.tag < roadRating ? .systemYellow : .systemBlue)
            }
            print(">> new road rating \(roadRating)")
        }
    }
    var overallRating = 0 {
        didSet {
            for starButton in overallRatingCollection {
                let imageName = (starButton.tag < overallRating ? "star.fill" : "star")
                starButton.setImage(UIImage(systemName: imageName), for: .normal)
                starButton.tintColor = (starButton.tag < overallRating ? .systemYellow : .systemBlue)
            }
            print(">> new ovarall rating \(overallRating)")
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        cyclePicker.delegate = self
        cyclePicker.dataSource = self
        self.hideKeyboardWhenTappedAround()
    }
    
    // MARK: - Helper Functions
    func checkForValidEntries() -> Bool {
        if routeNameTextField.text == "" {
            // TODO: - alert user to enter route name
            return false
        } else if selectedCycleType == nil {
            // TODO: - Alert user to select cycle type
            return false
        } else if sceneryRating == 0 {
            // TODO: - alert user to select scener rating
            return false
        } else if roadRating == 0 {
            // TODO: - alert user to select road rating
            return false
        } else if overallRating == 0 {
            // TODO: - alert user to select overall rating
            return false
        }
        return true
    }
    
    // MARK: - Actions
    @IBAction func sceneryRatingButtonTapped(_ sender: UIButton) {
        sceneryRating = sender.tag + 1
    }
    
    @IBAction func roadRatingButtonTapped(_ sender: UIButton) {
        roadRating = sender.tag + 1
    }
    
    @IBAction func ovarallRatingButtonTapped(_ sender: UIButton) {
        overallRating = sender.tag + 1
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        let success = checkForValidEntries()
        if success {
            if routeCoordinates.count != 3 {
                print("Route coordinate error!")
                return
            }
            RouteController.shared.createRouteWith(routeStartpoint: routeCoordinates[0],
                                                   routeMidpoint: routeCoordinates[1],
                                                   routeEndpoint: routeCoordinates[2],
                                                   routeName: routeNameTextField.text!,
                                                   cycleType: selectedCycleType!,
                                                   sceneryRating: Float(sceneryRating),
                                                   roadRating: Float(roadRating),
                                                   overallRating: Float(overallRating),
                                                   routeNotes: notesTextView.text ?? "") { success in
                if success {
                    print("Route succefully saved to iCloud!")
                    DispatchQueue.main.async {
                        // TODO: - alert the user that the route was saved
                        self.navigationController?.popViewController(animated: true)
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    print("Unable to save route to iCloud.")
                }
            }
        } 
    }
} // End of class

extension CreateDetailsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cycleTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = UILabel()
        if let v = view {
            label = v as! UILabel
        }
        label.font = UIFont (name: "Helvetica Neue", size: 17)
        label.text =  cycleTypes[row]
        label.textAlignment = .center
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCycleType = cycleTypes[row]
    }
} // End of extension

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
} // End of extension
