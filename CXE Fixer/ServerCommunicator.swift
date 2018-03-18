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
    
    struct Server {
        static let ip_address = "localhost"
        static let port_number = 8000
        static let nameSpace = "/fixerSocketIO"
        static var url: String {
            let ip = Server.ip_address
            let port = Server.port_number
            return "http://\(ip):\(port)/"
        }
    }
    
    override init() {
        super.init()
    }
    
    func enableSocketIO() {
        let manager = SocketManager(
            socketURL: URL(string: Server.url)!,
            config: [
//                .log(true),
                .forcePolling(true),
//                .compress,
                .reconnects(true),
                .reconnectWait(5),
            ]
        )
        let socket = manager.defaultSocket
//        let socket = manager.socket(forNamespace: Server.nameSpace)

        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            print(data)
        }
        
        socket.on("hi") { (data, ack) in
            print(data)
        }
        socket.connect(timeoutAfter: 2) {
            print("unable to connect")
        }
        print("trying to connect")
    }
}
