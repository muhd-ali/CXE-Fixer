//
//  WorkOrderTableViewCell.swift
//  CXE Fixer
//
//  Created by Muhammad Ali on 3/6/18.
//  Copyright © 2018 Customer Experience EcoSystem. All rights reserved.
//

import UIKit

class WorkOrderTableViewCell: UITableViewCell {
    @IBOutlet weak var problemTypeLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var workOrder: WorkOrder? {
        didSet {
            if workOrder != nil {
                updateUI(with: workOrder!)
            }
        }
    }
    
    private func updateUI(with workOrder: WorkOrder) {
        self.problemTypeLabel.text = workOrder.problemType
        self.departmentLabel.text = workOrder.department
        var distanceText = "cannot calculate distance"
        if let distanceInMeters = workOrder.location.distance {
            let distanceInMiles = distanceInMeters / 1609.344
            distanceText = "\(Int(distanceInMiles)) mi"
        }
        self.distanceLabel.text = distanceText
    }
}
