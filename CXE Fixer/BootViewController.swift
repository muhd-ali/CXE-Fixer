//
//  BootViewController.swift
//  CXE Fixer
//
//  Created by Muhammad Ali on 3/6/18.
//  Copyright © 2018 Customer Experience EcoSystem. All rights reserved.
//

import UIKit
import PKHUD

class BootViewController: UIViewController {
    private func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "Location Access Disabled",
                                                message: "Your location is needed at all times to show you the nearest tasks.",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Settings", style: .default) { (action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func makeSureLocationIsEnabled() {
        let gpsLocation = Location.GPS.shared
        gpsLocation.delegate = self
        gpsLocation.locationManager.requestAlwaysAuthorization()
        if !gpsLocation.hasAlwaysAccess {
            self.showLocationDisabledPopUp()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.makeSureLocationIsEnabled()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        HUD.show(.progress)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

}

extension BootViewController: GPSLocationDelegate {
    func locationIsAvailable() {
        HUD.hide()
        self.performSegue(withIdentifier: "presentWorkOrdersTableViewController", sender: nil)
    }
}
