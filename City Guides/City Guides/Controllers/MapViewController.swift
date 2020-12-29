//
//  MapViewController.swift
//  City Guides
//
//  Created by Thekra Abuhaimed. on 03/05/1442 AH.
//

import UIKit
import GoogleMaps
import RealmSwift

class MapViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    
    // MARK: - Constants & Variables
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted: CGFloat = 0
    var cardVisible = false
    var nextState: CardState {
        return cardVisible ? .collapsed : .expanded
    }
    
    var request = YelpRequest()
    var categories = [(BusinessRealm, String)]() {
        didSet {
            addMarkers()
        }
    }
    var businesses = [BusinessRealm]() {
        didSet {
            addCategory()
        }
    }
    var coor = CLLocationCoordinate2D() {
        didSet {
            print("coorMap", coor)
            setupCamera()
            fetchBusinesses()
        }
    }
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.shared.determineCurrentLocation()
        NotificationCenter.default.addObserver(self, selector: #selector(updateCoor), name: NSNotification.Name(rawValue: "updateCoor"), object: nil)
        setupMapView()
        addGestures()
    }
}

// MARK: - GoogleMaps Delegate
extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        performSegue(withIdentifier: "marker", sender: marker)
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
            UIApplication.shared.open(NSURL(string:"comgooglemaps://?saddr=&daddr=\(marker.position.latitude),\(marker.position.longitude)&directionsmode=driving")! as URL, options: [:], completionHandler: nil)
        } else {
            showAlert(title: "Google Maps not found", message: "Please install Google Maps in your device.")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "marker" {
            let nextVC =  segue.destination as! BusinessDetailsViewController
            if let marker = sender as? GMSMarker,
               let dict = marker.userData as? BusinessRealm {
                nextVC.busi = dict
            }
        }
    }
}

// MARK: - Functions
extension MapViewController {
    
    @objc func updateCoor(_ notification: Notification) {
        if let data = notification.object as? CLLocationCoordinate2D {
            coor = data
        }
    }
    
    func setupMapView() {
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapView.mapStyle(withFilename: "dark", andType: "json")
    }
    
    func setupCamera() {
        let camera = GMSCameraPosition.camera(withLatitude: coor.latitude, longitude: coor.longitude, zoom: 13)
        mapView.animate(to: camera)
    }
    
    func fetchBusinesses() {
        if Reachability.isConnectedToNetwork() {
            BusinessesManager().fetchBusinesses(coordinates: coor) { [self] (busi) in
                businesses = Array(busi.businesses)
            }
        }  else {
            print("Internet Connection not Available!")
            businesses = Array(RealmManager.getAllBusinesses()!)
        }
    }
    
    func addCategory() {
        let group = DispatchGroup()
        for busi in businesses {
            group.enter()
            print(busi.categories[0].alias)
            #warning("Save in realm")
            request.fetchCategory(alias: busi.categories[0].alias) { [self] (result) in
                
                switch result {
                case let .success(category):
                    print("Successfully found category")
                    
                    categories.append((busi, category.category.parentAliases.first ?? ""))
                    
                case let .failure(error):
                    print("Error fetching category: \(error)")
                }
                group.leave()
            }
            //            sleep(1)
        }
        group.notify(queue: DispatchQueue.main, execute: { [self] in
            addMarkers()
            print("Finished all requests.")
        })
    }
    
    func addMarkers() {
        for busi in categories {
            let marker = GMSMarker()
            marker.userData = busi.0
            marker.icon = UIImage(named: categoryImage(busi: busi.1))
            marker.title = busi.0.name
            marker.snippet = busi.1
            marker.position = CLLocationCoordinate2D(latitude: busi.0.coordinates!.latitude,
                                                     longitude: busi.0.coordinates!.longitude)
            marker.map = mapView
        }
    }
    
    func categoryImage(busi: String) -> String {
        var cate = ""
        switch busi {
        case "restaurants":
            cate = "res-marker"
        case "active":
            cate = "activity-marker"
        case "parks":
            cate = "park-marker"
        case "food":
            cate = "food-marker"
        case "arts":
            cate = "art-marker"
        case "mexican":
            cate = "mexican-marker"
        case "japanese":
            cate = "japanese-marker"
        case "museums":
            cate = "musem-marker"
        default:
            cate = "marker"
        }
        return cate
    }
}

// MARK: - Handling ContainerView
extension MapViewController {
    
    func addGestures() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleCardPan(recognizer:)))
        containerView.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc
    func handleCardPan (recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startInteractiveTransition(state: nextState, duration: 0.9)
        case .changed:
            let translation = recognizer.translation(in: self.containerView)
            var fractionComplete = translation.y / containerView.frame.height
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            continueInteractiveTransition()
        default:
            break
        }
        
    }
    
    func animateTransitionIfNeeded (state: CardState, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) { [self] in
                switch state {
                case .expanded:
                    containerView.frame.origin.y = self.view.frame.height - containerView.frame.height
                case .collapsed:
                    containerView.frame.origin.y = self.view.frame.height - 196
                }
            }
            
            frameAnimator.addCompletion { _ in
                self.cardVisible = !self.cardVisible
                self.runningAnimations.removeAll()
            }
            
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
            
        }
    }
    
    func startInteractiveTransition(state: CardState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    func updateInteractiveTransition(fractionCompleted: CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    
    func continueInteractiveTransition() {
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
}

// MARK: - Enums
extension MapViewController {
    enum CardState {
        case expanded
        case collapsed
    }
}
