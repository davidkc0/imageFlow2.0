//
//  LogInViewController.swift
//  imageFlow
//
//  Created by David Ciaffoni on 7/19/16.
//  Copyright © 2016 David Ciaffoni. All rights reserved.
//

import UIKit
import Parse

class LogInViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    

    @IBAction func loginAction(sender: AnyObject) {
        let username = self.emailField.text
        let password = self.passwordField.text
        
        // Validate the text fields
        if (username?.utf16.count < 8) {
            let alert = UIAlertController(title: "Invalid", message: "Username must be greater than 5 characters", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(OKAction)
            
        } else if (password?.utf16.count < 8) {
            let alert = UIAlertController(title: "Invalid", message: "Password must be greater than 8 characters", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(OKAction)
            
        } else {

            
            // Send a request to login
            PKHUD.sharedHUD.contentView = PKHUDRotatingImageView(image: PKHUDAssets.progressCircularImage, title: "", subtitle: "")
            PKHUD.sharedHUD.show()
            PFUser.logInWithUsernameInBackground(username!, password: password!, block: { (user, error) -> Void in
                
              
                
                if ((user) != nil) {
                    self.dismissViewControllerAnimated(true, completion: nil)
                    PKHUD.sharedHUD.hide()
                } else {
                    let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alert.addAction(OKAction)
                    
                }
            })
        }
    }
    
    @IBAction func unwindToLogInScreen(segue:UIStoryboardSegue) {
    }
}
