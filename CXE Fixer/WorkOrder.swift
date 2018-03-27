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
    let department: Department
    let problemType: ProblemType
    let location: Location
    let note: String
    
    init(server_id: String, department: String, problemType: String, location: Location, note: String) {
        self.server_id = server_id
        self.department = Department(server_id: "", title: department)
        self.problemType = ProblemType(server_id: "", title: problemType)
        self.location = location
        self.note = note
        super.init()
    }
    
    init(from json: [String: Any]) {
        self.server_id = ""
        let department = json["department"] as! [String: String]
        self.department = Department(from: department)
        
        let problemType = json["problemType"] as! [String: String]
        self.problemType = ProblemType(from: problemType)
        
        let location = json["location"] as! [String: Any]
        self.location = Location(from: location)
        
        self.note = json["note"] as! String
        super.init()
    }
}
