//
//  MenuTableViewController.swift
//  EchoNotification
//
//  Created by echo on 9/2/17.
//  Copyright © 2017 echo. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    
    var menuOptions: Array = Array<MenuOption>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Menu"
        self.setupMenuOptions()
    }
    
    func setupMenuOptions() {
        self.menuOptions.append(MenuOption(description: "Device Info") { [weak self] in
            let viewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DeviceInfoViewController")
            self?.navigationController?.show(viewController, sender: self)
        })
        self.menuOptions.append(MenuOption(description: "Notification Samples") { [weak self] in
            let viewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LocalNotificationViewController")
            self?.navigationController?.show(viewController, sender: self)
        })
        self.menuOptions.append(MenuOption(description: "Rich Notification URL Test") { [weak self] in
            let viewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RichNotificationViewController")
            self?.navigationController?.show(viewController, sender: self)
        })
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuOptions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath)
        cell.textLabel?.text = menuOptions[indexPath.row].description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        menuOptions[indexPath.row].action()
    }
}
