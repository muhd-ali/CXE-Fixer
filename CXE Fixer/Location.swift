//
//  Location.swift
//  CXE Fixer
//
//  Created by Muhammad Ali on 3/5/18.
//  Copyright © 2018 Customer Experience EcoSystem. All rights reserved.
//

import Foundation
import CoreLocation

protocol GPSLocationDelegate {
    func locationIsAvailable()
}

class Location: NSObject {
    class GPS: NSObject, CLLocationManagerDelegate {
        static let shared = GPS()
        let locationManager = CLLocationManager()
        var hasAlwaysAccess = false
        var delegate: GPSLocationDelegate?
        var location: CLLocation?
        private var isAvailable = false
        
        var json: [String: Double] {
            if let latitude = self.location?.coordinate.latitude,
                let longitude = self.location?.coordinate.longitude {
                return [
                    "latitude": latitude,
                    "longitude": longitude
                ]
            }
            return [:]
        }
        
        override init() {
            super.init()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            self.setAvailability()
        }
        
        private func setAvailability() {
            if CLLocationManager.locationServicesEnabled() {
                let status = CLLocationManager.authorizationStatus()
                if status == .authorizedAlways {
                    self.hasAlwaysAccess = true
                    return
                }
            }
            self.hasAlwaysAccess = false
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.first {
                self.location = location
                if !self.isAvailable {
                    self.isAvailable = true
                    self.delegate?.locationIsAvailable()
                }
                WorkOrders.shared.updateOrder()
                ServerCommunicator.shared.send(location: self.json)
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            self.setAvailability()
        }
    }

    let coordinates: CLLocationCoordinate2D
    let specificsJson: [String:String]
    var distance: Double? {
        if let myLocation = GPS.shared.location {
            let workLocation = CLLocation(
                latitude: self.coordinates.latitude,
                longitude: self.coordinates.longitude
            )
            if CLLocationCoordinate2DIsValid(workLocation.coordinate) {
                return workLocation.distance(from: myLocation)
            }
        }
        return nil
    }
    
    var specificsString: String {
        var str = ""
        print("spec json: \(self.specificsJson)")
        for (title, option) in self.specificsJson {
            if str.isEmpty {
                str = title + " - " + option
            } else {
                str = str + ", " + title + " - " + option
            }
        }
        return str
    }
    
    init(coordinates: CLLocationCoordinate2D, specificsJson: [String:String]) {
        self.coordinates = coordinates
        self.specificsJson = specificsJson
        super.init()
    }
    
    init(from json: [String: Any]) {
        let coordinatesInJson = json["gps"] as! [String:Double]
        self.coordinates = CLLocationCoordinate2D(latitude: coordinatesInJson["latitude"]!, longitude: coordinatesInJson["longitude"]!)
        self.specificsJson = json["specifics"] as! [String:String]
        super.init()
    }
}
