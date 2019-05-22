//
//  NotificationService.swift
//  EchoNotificationService
//
//  Created by echo on 9/9/17.
//  Copyright © 2017 echo. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {
    
    /**
     When debug is true, errors are displayed as notifications.
     Low memory issues will NOT get an error notification!  The UNNotificationServiceExtension is just killed.
     */
    let debug = true
    var startTime = Date()
    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        
        self.startTime = Date()
        self.contentHandler = contentHandler
        self.bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        // parse payload, this is service specific
        let assetURLString = request.content.userInfo["assetURL"] as! String
        
        if let assetURL = URL(string: assetURLString) {
            // UNNotificationAttachment requires attachments be saved locally
            self.downloadAttachment(url: assetURL)
        } else {
            self.errorNotification(message: "Check URL is valid. \(String(describing: assetURLString))")
        }
    }
    
    func downloadAttachment(url: URL) {
        
        // Use downloadTask to limit memory usage!  Otherwise you'll limit yourself to very small media files.
        URLSession.shared.downloadTask(with: URLRequest(url: url)) { (fileURL, response, error) in
            if error == nil && fileURL != nil {
                
                // By default, UNNotificationAttachment requires the file end with a supported file type.
                // Lets assume the URL ends with the proper file type.
                let fileName = url.lastPathComponent
                self.renameFile(fileURL: fileURL!, fileName: fileName)
                
                // Instead of renaming the file to end with the proper file type, you can provide a file type hint.
                // You'll need to import MobileCoreServices for access to the file type constants
                //self.notificationWith(fileURL: fileURL!, fileTypeHint: kUTTypePNG)
                
            } else {
                self.errorNotification(message: "\(String(describing: error))")
            }
        }.resume()
    }
    
    // See the following Apple documentation for valid fileTypeHints
    // https://developer.apple.com/documentation/usernotifications/unnotificationattachment
    func notificationWith(fileURL: URL, fileTypeHint: String) {
        do {
            let options = [UNNotificationAttachmentOptionsTypeHintKey: fileTypeHint]
            let attachment = try UNNotificationAttachment(identifier: fileURL.lastPathComponent, url: fileURL, options: options)
            self.notificationWith(attachment: attachment)
        } catch {
            self.errorNotification(message: "\(String(describing: error))")
        }
    }
    
    // rename downloaded file to end with the proper file type
    func renameFile(fileURL: URL, fileName: String) {
        let fileManager = FileManager.default
        let tmpSubFolderName = ProcessInfo.processInfo.globallyUniqueString
        let tmpSubFolderURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tmpSubFolderName, isDirectory: true)
        
        do {
            try fileManager.createDirectory(at: tmpSubFolderURL!, withIntermediateDirectories: true, attributes: nil)
            if let newURL = tmpSubFolderURL?.appendingPathComponent(fileName) {
                try fileManager.moveItem(at: fileURL, to: newURL)
                
                // Create attachment and notify user
                let attachment = try UNNotificationAttachment(identifier: newURL.lastPathComponent, url: newURL, options: nil)
                self.notificationWith(attachment: attachment)
            } else {
                self.errorNotification(message: "Cannot rename media file")
            }
        } catch {
            self.errorNotification(message: "\(String(describing: error))")
        }
    }
    
    // Notification with attachment
    func notificationWith(attachment: UNNotificationAttachment) {
        if let contentHandler = self.contentHandler, let bestAttemptContent = self.bestAttemptContent {
            bestAttemptContent.attachments = Array()
            bestAttemptContent.attachments.append(attachment)
            contentHandler(bestAttemptContent)
        }
    }
    
    // Replace the default notification with an error message
    func errorNotification(message: String) {
        if debug, let contentHandler = self.contentHandler, let bestAttemptContent = self.bestAttemptContent {
            bestAttemptContent.title = "Failed in \(self.elapsedTime()) s"
            bestAttemptContent.body = message
            contentHandler(bestAttemptContent)
        }
    }
    
    func elapsedTime() -> String {
        let timeInterval: Double = Date().timeIntervalSince(self.startTime);
        return "\(timeInterval)"
    }
    
    // handle time out
    // Does NOT get called in low memory situations!
    override func serviceExtensionTimeWillExpire() {
        self.errorNotification(message: "Timed Out")
    }

}
