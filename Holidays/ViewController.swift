//
//  ViewController.swift
//  Holidays
//
//  Created by Kurt Feusi on 14.05.18.
//  Copyright © 2018 Kurt Feusi. All rights reserved.
//
// Map to be displayed when a entry is selected in MainView Table
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate {

    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    var locationManager = CLLocationManager()
    
    
    
    
    @IBAction func showSearchBar(_ sender: Any) {
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self as UISearchBarDelegate
        present(searchController, animated: true, completion: nil)
    }
    
    
    @IBOutlet var mapView: MKMapView!
    
    @IBAction func scaleMap(_ gestureRecognizer: UIPinchGestureRecognizer) {
      
        guard gestureRecognizer.view != nil else {return}
        
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            locationManager.stopUpdatingLocation()          // V1.1 avoid curious behaviour while scaling
            gestureRecognizer.view?.transform = (gestureRecognizer.view?.transform.scaledBy(x: gestureRecognizer.scale, y: gestureRecognizer.scale))!
            gestureRecognizer.scale = 1.0
        }
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init the zoom level
        let uilgpress = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.longpress(gestureRecognizer:)))
        uilgpress.minimumPressDuration = 2
        mapView.addGestureRecognizer(uilgpress)
        if activePlace > -1 {
            if let name = places[activePlace]["name"] {
                if let lat = places[activePlace]["lat"] {
                    if let lon = places[activePlace]["lon"] {
                        if let latitude = Double(lat){
                            if let longitude = Double(lon) {
                                let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                let region = MKCoordinateRegion(center: coordinate, span: span)
                                self.mapView.setRegion(region, animated: true)
                                
                                // add annotation from name
                                
                                let pointAnnotation = MKPointAnnotation()
                                pointAnnotation.title = name
                                pointAnnotation.coordinate = coordinate
                                self.mapView.addAnnotation(pointAnnotation)
                            }
                        }
                    }
                }
            }
            
        } else {
        
        locationManager.delegate = self             // delegate to ViewController
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        locationManager.stopUpdatingLocation()  // avoid back to current loc after search
        //1
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        if self.mapView.annotations.count != 0 {
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        //2
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            //3
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0]
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        let latDelta: CLLocationDegrees = 0.05
        let lonDelta: CLLocationDegrees = 0.05
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        
        let coordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: (latitude), longitude: (longitude))
        let region: MKCoordinateRegion = MKCoordinateRegion(center: coordinates, span: span)

        
        CLGeocoder().reverseGeocodeLocation(userLocation)  {(placemarks, error) in
            if error != nil {
                print(error!)
            } else {
                
                if let placemark = placemarks?[0] {
                    
                    var subThoroughfare = ""
                    if placemark.subThoroughfare != nil {
                        subThoroughfare = placemark.subThoroughfare!
                    }
                    var thoroughfare = ""
                    if placemark.thoroughfare != nil {
                        thoroughfare = placemark.thoroughfare!
                    }

                    var locality = ""
                    if placemark.locality != nil {
                        locality = placemark.locality!
                    }

        //            print(thoroughfare + " " + subThoroughfare + "\n" + locality + "\n")
                    
                    self.pointAnnotation = MKPointAnnotation()
                    
                    self.pointAnnotation.subtitle = thoroughfare + " " + subThoroughfare
                    self.pointAnnotation.title = locality
                    self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude , longitude: userLocation.coordinate.longitude)
                    self.mapView.addAnnotation(self.pointAnnotation)
                    
                }
            }
        }
        
        self.mapView.setRegion(region, animated: true)
    }           // end locationManager
    

    

    @objc func longpress(gestureRecognizer: UIGestureRecognizer) {
    if gestureRecognizer.state == UIGestureRecognizerState.began {
        // avoid multiple entries into function
        let touchPoint = gestureRecognizer.location(in: self.mapView)
        let coordinate = self.mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
    
        if self.mapView.annotations.count != 0 {
           annotation = self.mapView.annotations[0]
          self.mapView.removeAnnotation(annotation)
        }
   
        let pointAnnotation = MKPointAnnotation()       // ohne diese let => found nil in nachster Zeile ?!
        pointAnnotation.coordinate = coordinate
        
        // newly entered to add adress to annotation
        
        let getLat: CLLocationDegrees = coordinate.latitude
        let getLon: CLLocationDegrees = coordinate.longitude
        
        let mapCenter: CLLocation =  CLLocation(latitude: getLat, longitude: getLon)
        
        CLGeocoder().reverseGeocodeLocation(mapCenter)  {(placemarks, error) in
            if error != nil {
                print(error!)
            } else {
                
                if let placemark = placemarks?[0] {
                    
                    var subThoroughfare = ""
                    if placemark.subThoroughfare != nil {
                        subThoroughfare = placemark.subThoroughfare!
                    }
                    var thoroughfare = ""
                    if placemark.thoroughfare != nil {
                        thoroughfare = placemark.thoroughfare!
                    }
                    
                    var locality = ""
                    if placemark.locality != nil {
                        locality = placemark.locality!
                    }
                    
                    //            print(thoroughfare + " " + subThoroughfare + "\n" + locality + "\n")
                    
                    self.pointAnnotation = MKPointAnnotation()
                    
                    self.pointAnnotation.subtitle = thoroughfare + " " + subThoroughfare
                    self.pointAnnotation.title = locality
                    self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: mapCenter.coordinate.latitude , longitude: mapCenter.coordinate.longitude)
                    self.mapView.addAnnotation(self.pointAnnotation)
                    
                }
            }
        }
        
        
        // end newly entered
        
    }
}

    
    
    @IBAction func save(_ sender: Any) {
        if self.pointAnnotation.title != nil {
            var name = self.pointAnnotation.title
            if self.pointAnnotation.subtitle != nil {
                name = self.pointAnnotation.subtitle! + ", " + name!
            }
            let lat = self.pointAnnotation.coordinate.latitude
            let lon = self.pointAnnotation.coordinate.longitude
            places.append(["name": name!, "lat": String(lat), "lon": String(lon)])
            
             UserDefaults.standard.set(places, forKey: "places")    // save permanently
            // go back to Table View via segue defined in TableView
            performSegue(withIdentifier: "unwindToTable", sender: nil)
            
        }
    }
}
