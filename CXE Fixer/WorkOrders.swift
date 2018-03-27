//
//  WorkOrders.swift
//  CXE Fixer
//
//  Created by Muhammad Ali on 3/26/18.
//  Copyright © 2018 Customer Experience EcoSystem. All rights reserved.
//

import Foundation
import CoreLocation

protocol WorkOrdersDelegate {
    func listUpdated(to list: [WorkOrder])
}

class WorkOrders: NSObject {
    static let shared = WorkOrders()
    var delegate: WorkOrdersDelegate?
    
    var list: [WorkOrder] = [
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
        ] {
        didSet {
            delegate?.listUpdated(to: self.list)
        }
    }
    
    func updateOrder() {
        self.list = WorkOrders.sortByDistance(list: self.list)
    }
    
    private static func sortByDistance(list: [WorkOrder]) -> [WorkOrder] {
        let sorted = list.sorted(by: { (wo1, wo2) -> Bool in
            if let d1 = wo1.location.distance,
                let d2 = wo2.location.distance {
                return d1 < d2
            }
            return true
        })
        return sorted
    }
    
    func sorted(insert workOrder: WorkOrder) {
        self.list.append(workOrder)
        var index = self.list.count - 1
        while (index > 0) {
            let wo1 = self.list[index-1]
            let wo2 = self.list[index]
            if let d1 = wo1.location.distance,
                let d2 = wo2.location.distance {
                if (d2 < d1) {
                    self.list.swapAt(index-1, index)
                } else {
                    break
                }
            } else {
                break
            }
            index-=1
        }
    }
}
