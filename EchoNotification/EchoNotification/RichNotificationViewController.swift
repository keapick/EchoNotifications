//
//  RichNotificationViewController.swift
//  EchoNotification
//
//  Created by echo on 9/2/17.
//  Copyright © 2017 echo. All rights reserved.
//

import UIKit
import UserNotifications

class RichNotificationViewController: UIViewController {
    
    let helper = NotificationUtility()
    @IBOutlet var urlString: UITextField?
    @IBOutlet var logView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Rich Notification URL Test"
        self.helper.logHandler = { [weak self] (message: String) -> () in
            print(message)
            DispatchQueue.main.async {
                self?.logView?.text.append(message)
                self?.logView?.text.append("\n")
            }
        }
    }
    
    func clearLog() {
        self.logView?.text = ""
    }
    
    @IBAction func richNotification() {
        self.clearLog()
        
        if self.urlString?.text != nil {
            self.helper.notificationAssetFromURL(assetURLString: self.urlString!.text!, completionHandler: { (attachment) in
                // timestamp just to make each notification unique. iOS suppresses duplicates
                self.helper.localUserNotification(title: Date().debugDescription, body: "rich notification", attachment: attachment, category: nil, delayInSeconds: 10)
            })
        } else {
            self.helper.logHandler("URL is nil")
        }
    }
}
