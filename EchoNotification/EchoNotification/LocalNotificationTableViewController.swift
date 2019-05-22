//
//  LocalNotificationTableViewController.swift
//  EchoNotification
//
//  Created by echo on 9/2/17.
//  Copyright © 2017 echo. All rights reserved.
//

import UIKit
import UserNotifications

class LocalNotificationTableViewController: UITableViewController {
    
    var menuOptions: Array = Array<MenuOption>()
    let helper = NotificationUtility()
    
    // used to log status
    weak var logTableViewCell: LogTableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Notification Samples"
        self.setupMenuOptions()
        self.helper.logHandler = { [weak self] (message: String) -> () in
            print(message)
            DispatchQueue.main.async {
                self?.logTableViewCell?.logView?.text.append(message)
                self?.logTableViewCell?.logView?.text.append("\n")
            }
        }
    }
    
    func clearLog() {
        self.logTableViewCell?.logView?.text = ""
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuOptions.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // magic numbers to match the storyboard.  last I checked it's not easy to pull this from the board
        if indexPath.row == self.menuOptions.count-1 {
            return 230.0
        }
        return 44.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // return the log cell for the last item
        if indexPath.row == self.menuOptions.count-1 {
            if self.logTableViewCell == nil {
                self.logTableViewCell = tableView.dequeueReusableCell(withIdentifier: "LogTableViewCell", for: indexPath) as? LogTableViewCell
            }
            return self.logTableViewCell!
        }
        
        // handle all other cells
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath)
        cell.textLabel?.text = menuOptions[indexPath.row].description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        menuOptions[indexPath.row].action()
    }
    
    func setupMenuOptions() {
        // timestamp just to make each notification unique. iOS suppresses duplicates
        self.menuOptions.append(MenuOption(description: "Notification, 10s") { [weak self] in
            self?.clearLog()
            self?.helper.localNotification(title: Date().debugDescription, body: "notification", assetName: nil, assetExtension: nil, category: nil, delayInSeconds: 10)
        })
        self.menuOptions.append(MenuOption(description: "Notification, actionable, 10s") { [weak self] in
            self?.clearLog()
            self?.helper.localNotification(title: Date().debugDescription, body: "actionable notification", assetName: nil, assetExtension: nil, category: "ALARM", delayInSeconds: 10)
        })
        self.menuOptions.append(MenuOption(description: "Image Notification, 10s") { [weak self] in
            self?.clearLog()
            self?.helper.localNotification(title: Date().debugDescription, body: "image notification", assetName: "gull", assetExtension: "jpeg", category: nil, delayInSeconds: 10)
        })
        self.menuOptions.append(MenuOption(description: "Image Notification, actionable, 10s") { [weak self] in
            self?.clearLog()
            self?.helper.localNotification(title: Date().debugDescription, body: "actionable image notification", assetName: "gull", assetExtension: "jpeg", category: "ALARM", delayInSeconds: 10)
        })
        self.menuOptions.append(MenuOption(description: "Video Notification, 10s") { [weak self] in
            self?.clearLog()
            self?.helper.localNotification(title: Date().debugDescription, body: "video notification", assetName: "japan", assetExtension: "mov", category: nil, delayInSeconds: 10)
        })
        self.menuOptions.append(MenuOption(description: "Video Notification, actionable, 10s") { [weak self] in
            self?.clearLog()
            self?.helper.localNotification(title: Date().debugDescription, body: "actionable video notification", assetName: "crab", assetExtension: "mov", category: "ALARM", delayInSeconds: 10)
        })
        // I don't have free license audio recordings
//        self.menuOptions.append(MenuOption(description: "Audio Notification, 10s") { [weak self] in
//            self?.clearLog()
//            self?.helper.localNotification(title: Date().debugDescription, body: "audio notification", assetName: "London Calling", assetExtension: "mp3", category: nil, delayInSeconds: 10)
//        })
//        self.menuOptions.append(MenuOption(description: "Audio Notification, actionable, 10s") { [weak self] in
//            self?.clearLog()
//            self?.helper.localNotification(title: Date().debugDescription, body: "actionable audio notification", assetName: "Love Will Tear Us Apart", assetExtension: "mp3", category: "ALARM", delayInSeconds: 10)
//        })
        
        // last menuOption is replaced with a log
        self.menuOptions.append(MenuOption(description: "") { })
    }
}
