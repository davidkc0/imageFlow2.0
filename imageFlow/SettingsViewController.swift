//
//  SettingsViewController.swift
//  imageFlow
//
//  Created by David Ciaffoni on 7/19/16.
//  Copyright © 2016 David Ciaffoni. All rights reserved.
//

import UIKit
import Parse

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var emailIdentifierLabel: UILabel!
    @IBAction func logOutAction(sender: AnyObject){}
    @IBOutlet weak var userNameLabel: UILabel!
    
    
    @IBAction func logOut(sender: AnyObject) {
        self.logout()
    }
    
    func logout() {
        // Send a request to log out a user
        PFUser.logOut()
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LogInViewController") as! UIViewController
            self.presentViewController(viewController, animated: true, completion: nil)
        })
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
    }
    
    
    override func viewDidLoad() {
        // Show the current visitor's username
       if let pUserName = PFUser.currentUser()?["username"] as? String {
        self.userNameLabel.text = pUserName
        
}
        super.viewDidLoad()
        print(#function, self.navigationController)
//        let logoutButton = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: #selector(SettingsViewController.logout))
//        self.navigationItem.setRightBarButtonItem(logoutButton, animated: false)
        
    }
}