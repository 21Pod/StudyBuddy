//
//  EditProfileViewController.swift
//  Studybuddy
//
//  Created by Emma Jin on 4/8/22.
//

import UIKit
import AlamofireImage
import Parse

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profilePicView: UIImageView!
    @IBOutlet weak var displayNameField: UITextField!
    @IBOutlet weak var institutionField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initializeFields()
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let prevViewController = presentingViewController as? ProfileViewController {
            DispatchQueue.main.async {
                prevViewController.displayUserInfo()
            }
        }
    }
    
    @IBAction func onSaveProfile(_ sender: Any) {
        // update user info in parse database
        let displayName = displayNameField.text
        let institution = institutionField.text
        let bioText = bioTextField.text
        let imageData = profilePicView.image!.pngData()
        let picFile = PFFileObject(data: imageData!)
        
        
        let user = PFUser.current()!
    
        user["displayName"] = displayName
        user["institution"] = institution
        user["bio"] = bioText
        user["profilePic"] = picFile
        
        user.saveInBackground { (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func onPictureButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    func initializeFields() {
        // initialize fields according to current user info
        let user = PFUser.current()!
        
        displayNameField.text = (user["displayName"] ?? "") as? String
        bioTextField.text = (user["bio"] ?? "") as? String
        institutionField.text = (user["institution"] ?? "") as? String
        
        let imageFile = user["profilePic"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        profilePicView.af.setImage(withURL: url)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        let size = CGSize(width: 180, height: 180)
        let scaledImage = image.af.imageAspectScaled(toFit: size)
        let roundedImage = scaledImage.af.imageRounded(withCornerRadius: 90)
        
        profilePicView.image = roundedImage
        
        dismiss(animated: true, completion: nil)
        
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
