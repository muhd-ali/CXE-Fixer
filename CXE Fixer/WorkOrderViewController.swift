//
//  WorkOrderViewController.swift
//  CXE Fixer
//
//  Created by Muhammad Ali on 3/28/18.
//  Copyright © 2018 Customer Experience EcoSystem. All rights reserved.
//

import UIKit

class WorkOrderViewController: UIViewController {
    @IBOutlet weak var workOrderTableView: UITableView!
    @IBAction func acceptButtonPressed(_ sender: UIButton) {
    }
    
    var workOrder: WorkOrder!
    let fields: [WorkOrder.Field] = [
        .department,
        .problemType,
        .location,
        .note,
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.workOrderTableView.tableFooterView = UIView(frame: CGRect.zero)
        workOrderTableView.delegate = self
        workOrderTableView.dataSource = self
        self.title = "Work Order"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension WorkOrderViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let field = self.fields[indexPath.section]
        switch field {
        case .note:
            return 3 * Constant.rowHeight
        default:
            return Constant.rowHeight
        }
    }
}

extension WorkOrderViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.fields.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let field = self.fields[section]
        switch field {
        case .department, .problemType:
            let leafItem = self.workOrder.similarFields[field]!
            if (leafItem.server_id.isEmpty) {
                return 2
            } else {
                return 1
            }
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let field = self.fields[section]
        return field.description
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let field = self.fields[indexPath.section]
        var cell: UITableViewCell?
        switch field {
        case .note:
            cell = self.workOrderTableView.dequeueReusableCell(withIdentifier: "NoteRow", for: indexPath)
            if let textView = cell?.viewWithTag(1) as? UITextView {
                textView.text = self.workOrder.note
            }
        default:
            cell = self.workOrderTableView.dequeueReusableCell(withIdentifier: "LabelRow", for: indexPath)
            if let label = cell?.viewWithTag(1) as? UILabel {
                switch field {
                case .department, .problemType:
                    let leafItem = workOrder.similarFields[field]!
                    if (leafItem.server_id.isEmpty &&  indexPath.row == 0){
                        label.text = "Other"
                    } else {
                        label.text = leafItem.title
                    }
                case .location:
                    label.text = self.workOrder.location.specificsString
                default:
                    break
                }
            }
        }
        
        return cell!
    }
}

