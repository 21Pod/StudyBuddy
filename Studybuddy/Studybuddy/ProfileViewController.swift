//
//  ProfileViewController.swift
//  Studybuddy
//
//  Created by Emma Jin on 4/8/22.
// -------------------------------------------

import UIKit
import Parse
import AlamofireImage

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var bioTextLabel: UILabel!
    @IBOutlet weak var institutionTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // display user information
        super.viewDidAppear(animated)
        // print("IN viewDidAppear")
        displayUserInfo()
    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        print("in onLogout")
        PFUser.logOut()
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "loginViewController")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate else { return }
        
        delegate.window?.rootViewController = loginViewController
    }
    
    func displayUserInfo() {
        // function to display user's profile picture, display name, institution, and bio
        
        let user = PFUser.current()!
        
        displayNameLabel.text = (user["displayName"] ?? "") as? String
        bioTextLabel.text = (user["bio"] ?? "") as? String
        institutionTextLabel.text = (user["institution"] ?? "") as? String
        
        let imageFile = user["profilePic"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        profileImageView.af.setImage(withURL: url)
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
