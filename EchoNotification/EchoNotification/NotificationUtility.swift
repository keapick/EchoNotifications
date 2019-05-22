//
//  NotificationUtility.swift
//  EchoNotification
//
//  Created by echo on 9/2/17.
//  Copyright © 2017 echo. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationUtility {

    var logHandler: (String) -> () = { (message: String) -> () in
        print(message)
    }
    
    func localNotification(title: String, body: String, assetName: String?, assetExtension: String?, category: String?, delayInSeconds: Int) {
        self.logHandler(body)
        var attachment : UNNotificationAttachment?
        if assetName != nil && assetExtension != nil {
            attachment = self.notificationAssetFromMainBundle(assetName: assetName!, assetExtension: assetExtension!)
        }
        self.localUserNotification(title: title, body: body, attachment: attachment, category: category, delayInSeconds: delayInSeconds)
    }
    
    // iOS 10+, local notification
    func localUserNotification(title: String, body: String, attachment: UNNotificationAttachment?, category: String?, delayInSeconds: Int) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        if category != nil {
            content.categoryIdentifier = category!
        }
        
        if attachment != nil {
            var attachments: Array<UNNotificationAttachment> = Array()
            attachments.append(attachment!)
            content.attachments = attachments
        }
        
        var dateInfo = Calendar.current.dateComponents([.hour, .minute, .second], from: Date())
        dateInfo.second = dateInfo.second! + delayInSeconds
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
        
        let request = UNNotificationRequest(identifier: title, content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
            if error != nil {
                self.logHandler("\(String(describing: error))")
            }
        }
        self.logHandler("iOS 10+, local notification in 10s")
    }
    
    func notificationAssetFromMainBundle(assetName: String, assetExtension: String) -> UNNotificationAttachment? {
        self.logHandler("Loading asset from MainBundle")
        
        var attachment: UNNotificationAttachment?
        do {
            let assetURL = Bundle.main.url(forResource: assetName, withExtension: assetExtension)
            try attachment = UNNotificationAttachment.init(identifier: assetName, url: assetURL!, options: nil)
        } catch _ {
            self.logHandler("Failed to load asset from Bundle.main")
        }
        return attachment
    }
    
    func notificationAssetFromURL(assetURLString: String, completionHandler: @escaping (UNNotificationAttachment?) -> Void) {
        self.logHandler("Downloading asset")
        self.logHandler("Assets must download within 30 s")

        if let url = URL.init(string: assetURLString) {
            self.downloadAttachment(url: url, completionHandler: completionHandler)
        } else {
            self.logHandler("Failed init URL.  Check URL is valid")
        }
    }
    
    func downloadAttachment(url: URL, completionHandler: @escaping (UNNotificationAttachment?) -> Void) {
        let startTime = Date()
        
        // Use downloadTask to limit memory usage!  Otherwise you'll limit yourself to very small media files
        URLSession.shared.downloadTask(with: URLRequest(url: url)) { (fileURL, response, error) in
            if error == nil && fileURL != nil {
                
                let downloadTime: Double = Date().timeIntervalSince(startTime);
                self.logHandler("Downloaded in \(downloadTime) s\n")
                
                // By default, UNNotificationAttachment requires the file end with a file type
                // Lets assume the URL ends with the proper file type
                let fileName = url.lastPathComponent
                self.renameFile(fileURL: fileURL!, fileName: fileName, completionHandler: completionHandler)
            } else {
                self.logHandler("\(String(describing: error))")
            }
        }.resume()
    }
    
    func renameFile(fileURL: URL, fileName: String, completionHandler: @escaping (UNNotificationAttachment?) -> Void) {
        let fileManager = FileManager.default
        let tmpSubFolderName = ProcessInfo.processInfo.globallyUniqueString
        let tmpSubFolderURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tmpSubFolderName, isDirectory: true)
        
        do {
            try fileManager.createDirectory(at: tmpSubFolderURL!, withIntermediateDirectories: true, attributes: nil)
            if let newURL = tmpSubFolderURL?.appendingPathComponent(fileName) {
                try fileManager.moveItem(at: fileURL, to: newURL)
                
                let attachment = try UNNotificationAttachment(identifier: newURL.lastPathComponent, url: newURL, options: nil)
                completionHandler(attachment)
            } else {
                self.logHandler("Cannot rename media file")
            }
        } catch {
            self.logHandler("\(String(describing: error))")
        }
    }
}
