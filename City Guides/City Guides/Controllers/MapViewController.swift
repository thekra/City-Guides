//
//  MapViewController.swift
//  City Guides
//
//  Created by Thekra Abuhaimed. on 03/05/1442 AH.
//

import UIKit
import GoogleMaps

protocol UpdateCoor {
    func PassCoor(coor: CLLocationCoordinate2D)
}

class MapViewController: UIViewController, UpdateCoor {
//    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    enum CardState {
        case expanded
        case collaped
    }
    var busiVC = BusinessesViewController()
    // MARK: - IBOutlets
    @IBOutlet weak var mapView: GMSMapView!
    
    // MARK: - Constants & Variables
    var cardHeight: CGFloat = 600
    var cardHandle:CGFloat = 65
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted:CGFloat = 0
    var cardVisible = false
    var nextState: CardState {
        return cardVisible ? .collaped : .expanded
    }
    var request = YelpRequest()
    var businesses = [Business]() {
        didSet {
            addMarkers()
        }
    }
    var coor = CLLocationCoordinate2D() {
        didSet {
            setupCamera()
        }
    }
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocationManager.shared.determineCurrentLocation()
        LocationManager.delegate = self
        setupMapView()
        request.fetchBusinesses { [self] (result) in
            switch result {
            case let .success(photos):
                print("Successfully found \(photos.count) photos.")
                businesses = photos
            case let .failure(error):
                print("Error fetching photos: \(error)")
            }
        }
//        containerView.frame.origin.y = self.view.frame.height - 100 // not working
//        heightConstraint.constant = 100
//        containerHeight.constant = view.frame.height - 200
        addGestures()
    }
}

// MARK: - Functions
extension MapViewController {
    
    func setupMapView() {
        //mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapView.mapStyle(withFilename: "dark", andType: "json")
        //        let chooseButtonHeight = self.chooseButton.intrinsicContentSize.height
        //        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: chooseButtonHeight+10 , right: 0)
    }
    
    func setupCamera() {
        let camera = GMSCameraPosition.camera(withLatitude: coor.latitude, longitude: coor.longitude, zoom: 13)
        mapView.animate(to: camera)
    }
    
    func addMarkers() {
        for busi in businesses {
            let marker = GMSMarker()
            marker.icon = UIImage(named: "marker")
            marker.position = CLLocationCoordinate2D(latitude: busi.coordinates.latitude, longitude: busi.coordinates.longitude)
            marker.map = mapView
        }
    }
}

// MARK: - Handling ContainerView
extension MapViewController {
    
    func addGestures() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleCardTap(recognzier:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleCardPan(recognizer:)))
        
        containerView.addGestureRecognizer(tapGestureRecognizer)
        containerView.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc
    func handleCardTap(recognzier: UITapGestureRecognizer) {
        switch recognzier.state {
        case .ended:
            animateTransitionIfNeeded(state: nextState, duration: 0.9)
        default:
            break
        }
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
                    print("ex")
                    containerView.frame.origin.y = self.view.frame.height - containerView.frame.height
//                    self.containerHeight.constant = 10
//                    self.view.layoutIfNeeded()
                case .collaped:
                    print("co")
                    containerView.frame.origin.y = self.view.frame.height - 100
//                    self.containerHeight.constant = self.view.frame.height - 200
//                    self.view.layoutIfNeeded()
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
    
    func continueInteractiveTransition (){
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
}

// MARK: - Protocols
extension MapViewController {
    func PassCoor(coor: CLLocationCoordinate2D) {
        self.coor = coor
    }
}
