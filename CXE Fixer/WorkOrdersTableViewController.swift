//
//  WorkOrdersTableViewController.swift
//  CXE Fixer
//
//  Created by Muhammad Ali on 3/5/18.
//  Copyright © 2018 Customer Experience EcoSystem. All rights reserved.
//

import UIKit
import CoreLocation

class WorkOrdersTableViewController: UITableViewController {
    
    var data: [WorkOrder] = [
        WorkOrder(
            server_id: "w0",
            department: "Cleaning Dept",
            problemType: "Spill",
            location: Location(
                coordinates: CLLocationCoordinate2D(
                    latitude: 31.5204,
                    longitude: 74.3587
                )
            ),
            note: "Hey Boy. What's up?"
        ),
        WorkOrder(
            server_id: "w1",
            department: "Electrical Management",
            problemType: "Elevator Malfunction",
            location: Location(
                coordinates: CLLocationCoordinate2D(
                    latitude: 32.7767,
                    longitude: -96.7970
                )
            ),
            note: "Hey Boy. What's up?"
        )
    ]
    
    private func sortData() {
        data = data.sorted(by: { (wo1, wo2) -> Bool in
            if let d1 = wo1.location.distance,
               let d2 = wo2.location.distance {
               return d1 < d2
            }
            return true
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sortData()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        let shared = ServerCommunicator.shared
        shared.enableSocketIO()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkOrderRow", for: indexPath)
        if let workOrderCell = cell as? WorkOrderTableViewCell {
            workOrderCell.workOrder = self.data[indexPath.row]
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constant.rowHeight
    }
}

