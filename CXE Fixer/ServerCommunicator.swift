//
//  ServerCommunicator.swift
//  CXE Fixer
//
//  Created by Muhammad Ali on 3/16/18.
//  Copyright © 2018 Customer Experience EcoSystem. All rights reserved.
//

import Foundation
import SocketIO

class ServerCommunicator: NSObject {
    static let shared = ServerCommunicator()
    
    let manager = SocketManager(
        socketURL: URL(string: Server.url)!,
        config: [
            .compress,
            ]
    )
    
    var socket: SocketIOClient!
    
    struct Server {
        static let ip_address = "localhost"
        static let port_number = 8000
        static let nameSpace = "/fixerSocketIO"
        static var url: String {
            let ip = Server.ip_address
            let port = Server.port_number
            return "http://\(ip):\(port)"
        }
    }
    
    override init() {
        super.init()
        self.enableSocketIO()
    }
    
    func enableSocketIO() {
        self.socket = manager.socket(forNamespace: Server.nameSpace)

        self.socket.on(clientEvent: .connect) {data, ack in
            print("Connected to \(Server.url)")
            let location = Location.GPS.shared.json
            self.send(location: location)
        }
        
        self.socket.connect()
        self.addEvents(on: self.socket)
    }
    
    func addNewReportEvent(on socket: SocketIOClient) {
        socket.on("newReport") { (data, ack) in
            let workOrder = WorkOrder(from: data[0] as! [String:Any])
            WorkOrders.shared.sorted(insert: workOrder)
        }
    }
    
    func addEvents(on socket: SocketIOClient) {
        self.addNewReportEvent(on: socket)
    }
    
    func send(location: [String: Double]) {
        self.socket.emit("location", location)
    }
}
