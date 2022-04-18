//
//  FriendsViewController.swift
//  Studybuddy
//
//  Created by Emma Jin on 4/9/22.
//

import UIKit
import Parse
import MapKit

class FriendsViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var friendsMapView: MKMapView!
    
    let manager = CLLocationManager()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // asks for location when open app
        manager.requestWhenInUseAuthorization()
        
        // location accuracy
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        manager.delegate = self
        
        // start tracking user's location
        manager.startUpdatingLocation()
        
        loadFriends()
    }
    
    // called when startUpDatingLocation()
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // locations is an array of locs sent by manager. Just get the first one as we're in simulator
        if let location = locations.first {
            
            // stop getting location then render
            manager.stopUpdatingLocation()
            
            render(location)
            
        }
    }
    
    func render(_ location: CLLocation) {
        
        // get coordinates
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        // determine zoom span
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        friendsMapView.setRegion(region, animated: true)
        
        let pin = MKPointAnnotation()
        
        pin.coordinate = coordinate
        
        friendsMapView.addAnnotation(pin)
    }
    
    @IBAction func findFriends() {
        showClassesActionSheet()
    }
    
    var friends = [PFObject]()
    
    let courses=["Remote IOS Spring", "Mobile App Development", "Technical Interview Prep"]
    
    func loadFriends(){
        let query = PFQuery(className: "Friends")
        query.includeKeys(["name", "location", "status", "sharingLocation", "course"])
        
        query.findObjectsInBackground { (friends, error) in
            if friends != nil {
                self.friends = friends!
            }
        }
    }
    
    func displayLocation(friend: PFObject) {
        
        // first fetch friend's status, if not sharing then don' display
        if let status = friend["sharingLocation"] {
            // fetch friend's location
            let location = (friend["location"] as? PFGeoPoint)!
            
            let myCoordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            
            let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            
            let region = MKCoordinateRegion(center: myCoordinate, span: span)
            
            self.friendsMapView.setRegion(region, animated: true)
            
            let name = friend["name"] as! String
            
            let bio = (friend["bio"] != nil) ? friend["bio"] : ""
            
            let pin = createPin(coordinate: myCoordinate, name: name, bio: bio as! String)
            
            friendsMapView.addAnnotation(pin)
        }
        
    
    }
    
    func createPin(coordinate: CLLocationCoordinate2D, name: String, bio: String) -> MKPointAnnotation {
        let pin = MKPointAnnotation()
        pin.title = name
        pin.subtitle = bio
        pin.coordinate = coordinate
        return pin
    }
    
    
    func showClassesActionSheet() {
        let classesActionSheet = UIAlertController(title: "Choose Class", message: nil, preferredStyle: .actionSheet)
        
        courses.forEach{course in
            
            classesActionSheet.addAction(UIAlertAction(title: course, style: .default, handler: { [self] action in
                friends.forEach { friend in
                    if (friend["course"] as! String == course) {
                        displayLocation(friend: friend)
                    }
                }
            }))
        }
        
        classesActionSheet.addAction(UIAlertAction(title: "All", style: .default, handler: { [self] action in
            friends.forEach { friend in
                displayLocation(friend: friend)
            }
        }))
        
        classesActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(classesActionSheet, animated: true)
    }
}
