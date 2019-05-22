//
//  AppDelegate.swift
//  EchoNotification
//
//  Created by echo on 9/2/17.
//  Copyright © 2017 echo. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    public var deviceToken: String?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.requestNotificationAuthorization()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

// notification permissions
extension AppDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        self.deviceToken = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Push Device Token: \(String(describing: self.deviceToken))")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications. \(String(describing: error))")
    }
    
    func requestNotificationAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            
            guard granted else {
                print("Failed to register for remote notifications. \(String(describing: error))")
                return
            }
            
            // setup a category for actionable notifications
            let snoozeAction = UNNotificationAction(identifier: "SNOOZE_ACTION", title: "Snooze", options: UNNotificationActionOptions(rawValue: 0))
            let stopAction = UNNotificationAction(identifier: "STOP_ACTION", title: "Stop", options: .foreground)
            
            let generalCategory = UNNotificationCategory(identifier: "ALARM", actions: [snoozeAction, stopAction], intentIdentifiers: [], options: .customDismissAction)
            
            center.setNotificationCategories([generalCategory])
            center.delegate = self
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}

// notification handling iOS 10+
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // handles custom actions on a notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Notification action selected! \(response)")
        completionHandler()
    }
    
    // called when a notification arrives while the app is foregrounded
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        print("Got notification! \(notification)")
        
        // existing notification handling
        completionHandler(.alert)
    }
}
