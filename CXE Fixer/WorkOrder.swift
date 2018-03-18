//
//  WorkOrder.swift
//  CXE Fixer
//
//  Created by Muhammad Ali on 3/5/18.
//  Copyright © 2018 Customer Experience EcoSystem. All rights reserved.
//

import Foundation

class WorkOrder: NSObject {
    let server_id: String
    let department: String
    let problemType: String
    let location: Location
    let note: String
    
    init(server_id: String, department: String, problemType: String, location: Location, note: String) {
        self.server_id = server_id
        self.department = department
        self.problemType = problemType
        self.location = location
        self.note = note
        super.init()
    }
}
