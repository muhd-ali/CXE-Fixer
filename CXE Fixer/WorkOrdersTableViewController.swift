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
    
    var data: [WorkOrder] = WorkOrders.shared.list
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WorkOrders.shared.delegate = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.title = "Work Orders"
        self.navigationController?.navigationBar.prefersLargeTitles = true
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
        return 2 * Constant.rowHeight
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showWorkOrderViewController") {
            if let dvc = segue.destination as? WorkOrderViewController,
               let indexPath = self.tableView.indexPathForSelectedRow {
                dvc.workOrder = self.data[indexPath.row]
            }
        }
    }
}

extension WorkOrdersTableViewController: WorkOrdersDelegate {
    func listUpdated(to list: [WorkOrder]) {
        self.data = list
        self.tableView.reloadData()
    }
}
