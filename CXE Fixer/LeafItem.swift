//
//  LeafItem.swift
//  CXE Reporter
//
//  Created by Muhammad Ali on 3/18/18.
//  Copyright © 2018 Customer Experience EcoSystem. All rights reserved.
//

import Foundation

class LeafItem: Selectable {
    enum ControlType {
        case notListed
        case none
    }
    var controlType = ControlType.none
    
    func update(from leafItem: LeafItem) {
        super.update(from: leafItem)
        self.controlType = leafItem.controlType
    }
}
