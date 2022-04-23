//
//  CreateDetailsViewController.swift
//  BikerMaps
//
//  Created by Keith Mair on 4/22/22.
//

import UIKit
import CoreLocation

class CreateDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var routeNameTextField: UITextField!
    @IBOutlet weak var cyclePicker: UIPickerView!
//    @IBOutlet weak var sceneryRatingView: UIView!
//    @IBOutlet weak var roadRatingView: UIView!
//    @IBOutlet weak var overallRatingView: UIView!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var sceneryRatingStackView: RatingController!
    @IBOutlet weak var roadRatingStackView: RatingController!
    @IBOutlet weak var overallRatingStackView: RatingController!

    // MARK: - Properties
    let cycleTypes = ["Scroll to select", CycleType.roadBicycle, CycleType.roadMotorcycle, CycleType.mountainBike, CycleType.dirtBike, CycleType.dualSport]
    var routeCoordinates: [CLLocationCoordinate2D] = []
    var selectedCycleType: String?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        cyclePicker.delegate = self
        cyclePicker.dataSource = self
        setupViews()
    }
    
    func setupViews() {
        sceneryRatingView.addSubview(<#T##view: UIView##UIView#>)
//        (RatingView(rating: .constant(3)))
    }
    
    // MARK: - Helper Functions
    func checkForValidEntries() {
        
        guard let routeName = routeNameTextField.text,
              !routeName.isEmpty
        else {
            // TODO: - Alert user to enter route name
            return
        }
        if selectedCycleType == "Scroll to select" {
            // TODO: - Alert user to select cycle type
            return
        }
    }
    
    // MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        checkForValidEntries()
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
