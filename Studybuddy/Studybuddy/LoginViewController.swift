//
//  LoginViewController.swift
//  Studybuddy
//
//  Created by Yelaman Sain on 4/5/22.
//  Edited by Emma Jin on 4/8/22.

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    
    
    @IBAction func onSignin(_ sender: Any) {
        let username = usernameField.text!
        let password = passwordField.text!
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
          if user != nil {
              self.performSegue(withIdentifier: "loginSegue", sender: nil)
          } else {
              print("Error: \(String(describing: error?.localizedDescription))")
          }
        }
    }
    
    
    @IBAction func onSignup(_ sender: Any) {
        let user = PFUser()
        
        // store username & password, initialize other fields for display in profile
        user.username = usernameField.text
        user.password = passwordField.text

        user["displayName"] = user.username
        //user["institution"] = ""
        //user["courseList"] = []
        //user["bio"] = ""
        
        let imageName = "image_placeholder.png"
        let image = UIImage(named: imageName)!
        
        let imageData = image.pngData()!
        let imageFile = PFFileObject(name:"image_placeholder.png", data:imageData)

        user["profilePic"] = imageFile
        
        user.signUpInBackground { (success, error) in
            if success {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                // if the user haven't verified email yet (which is always the case for a new user who signed up with a username, ask the user for an email first
                
                // then, if the user has successfully verified their email, store the email, set emailVerified to true, and segue to home page
            } else {
                print("Error: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
