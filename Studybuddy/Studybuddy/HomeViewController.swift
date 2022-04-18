//
//  HomeViewController.swift
//  Studybuddy
//
//  Created by Yelaman Sain on 4/5/22.
//  Edited by Emma Jin on 4/8/22.

import UIKit
import Parse
import MapKit
import CoreLocation

class HomeViewController: UIViewController, CLLocationManagerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Will set up map here
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // Ryan's map screen. Referenced from: https://www.youtube.com/watch?v=f6xN2MuHv1s&t=140s
    @IBOutlet var mapView: MKMapView!
    
    let manager = CLLocationManager()
    
    var myCoordinate = CLLocationCoordinate2D()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // asks for location when open app
        manager.requestWhenInUseAuthorization()
        
        // location accuracy
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        manager.delegate = self
        
        // start tracking user's location
        manager.startUpdatingLocation()
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
        myCoordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        // determine zoom span
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        
        let region = MKCoordinateRegion(center: myCoordinate, span: span)
        
        mapView.setRegion(region, animated: true)
        
        mapView.addAnnotation(createPin())
    }
    
    func createPin() -> MKPointAnnotation {
        let pin = MKPointAnnotation()
        pin.title = PFUser.current()?.username
        pin.subtitle = "(You)"
        pin.coordinate = myCoordinate
        return pin
    }
    
    
    func postLocation(course: String, coordinate: CLLocationCoordinate2D) {
        let location = PFObject(className: "Locations")

        location["user"] = PFUser.current()!
        location["coordinate"] = PFGeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
        location["class"] = course
        
        location.saveInBackground {
            (success, error) in
            if (success) {
                print("Location saved")
            } else {
                print("Can't share")
            }
        }
    }
    
    // Sharing location
    @IBAction func shareLocation() {
        showClassesActionSheet()
    }
    
    let courses=["Remote IOS Spring", "Mobile App Development", "Technical Interview Prep"]
    
    // referenced from https://www.youtube.com/watch?v=yVwQ7oWMxnk
    func showAlert(course: String) {
        let alert = UIAlertController(title: "Shared successfully", message: "Friends in \(course) can see your location now.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    func showClassesActionSheet() {
        let classesActionSheet = UIAlertController(title: "Choose Class", message: nil, preferredStyle: .actionSheet)
        
        courses.forEach { course in
            classesActionSheet.addAction(UIAlertAction(title: course, style: .default, handler: { [self] action in
                self.postLocation(course:"\(course)", coordinate: myCoordinate)
                showAlert(course: course)
            }))
        }
        
        classesActionSheet.addAction(UIAlertAction(title: "All", style: .default, handler: { [self] action in
            self.postLocation(course:"Technical Interview Prep", coordinate: myCoordinate);
            showAlert(course: "all courses")
        }))
        
        classesActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(classesActionSheet, animated: true)
    }
    

}
