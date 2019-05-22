//
//  DeviceInfoViewController.swift
//  EchoNotification
//
//  Created by echo on 9/2/17.
//  Copyright © 2017 echo. All rights reserved.
//

import UIKit
import AdSupport
import iAd

class DeviceInfoViewController: UIViewController {
    
    @IBOutlet var deviceInfoTextView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Device Info"

        printDeviceToken()
        printAdvertisingId()
        printIdForVendor()
        printIADInfo()
    }
    
    func printDeviceToken() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let deviceToken = appDelegate.deviceToken ?? "N/A"
        self.deviceInfoTextView?.text.append("Device Push Token\n" + deviceToken + "\n\n")
    }
    
    func printAdvertisingId() {
        self.deviceInfoTextView?.text.append("Apple Advertising ID\n" + ASIdentifierManager.shared().advertisingIdentifier.uuidString + "\n\n")
    }
    
    func printIdForVendor() {
        let idForVendor = UIDevice.current.identifierForVendor?.uuidString ?? "N/A"
        self.deviceInfoTextView?.text.append("Apple ID for Vendor\n" + idForVendor + "\n\n")
    }
    
    // Apple provides sample iAd data when run on a test device
    func printIADInfo() {
        ADClient.shared().requestAttributionDetails { (attributionDetails, error) in
            DispatchQueue.main.async {
                self.deviceInfoTextView?.text.append("iAd Attribution\n")
                self.deviceInfoTextView?.text.append(attributionDetails.debugDescription + "\n")
            }
        }
    }
}
