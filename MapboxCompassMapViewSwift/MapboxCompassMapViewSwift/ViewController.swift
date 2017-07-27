//
//  ViewController.swift
//  MapboxCompassMapViewSwift
//
//  Created by Jordan Kiley on 7/19/17.
//  Copyright © 2017 Mapbox. All rights reserved.
//
import Mapbox
import ARKit
import SceneKit

class ViewController: UIViewController, MGLMapViewDelegate, ARSCNViewDelegate {
    
    var compass : MBXCompassMapView!
    var sceneView = ARSCNView()
    override func viewDidLoad() {
        super.viewDidLoad()
        compass = MBXCompassMapView(frame: CGRect(x: 20,
                                                  y: 20,
                                                  width: view.bounds.width / 3,
                                                  height: view.bounds.width / 3),
                                    styleURL: URL(string: "mapbox://styles/jordankiley/cj5eeueie1bsa2rp4swgcteml"))
        
        compass.isMapInteractive = false
        compass.tintColor = .black
        compass.isEnlargeEnabled = true
        view.addSubview(compass)
        createSceneView()
        setConstraints()
        var button = compass.attributionButton
        let constraints = compass.attributionButton.constraints
        button.isHidden = false
        button.frame = CGRect(x: 10, y: 20, width: compass.attributionButton.frame.width, height: compass.attributionButton.frame.height)
        view.addSubview(button)
    }
    
    override func viewDidLayoutSubviews() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1, animations: {
            self.compass.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
            self.compass.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        })

    }
    func setConstraints() {
        //            addConstraint(NSLayoutConstraint(item: superview, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20))
        self.compass.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        compass.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        
        if UIDevice.current.orientation == .portrait {
            compass.heightAnchor.constraint(
                equalTo: view.widthAnchor,
                multiplier: 0.33).isActive = true
            compass.widthAnchor.constraint(
                equalTo: view.widthAnchor,
                multiplier: 0.33).isActive = true
        } else {
            compass.heightAnchor.constraint(
                equalTo: view.heightAnchor,
                multiplier: 0.33).isActive = true
            compass.widthAnchor.constraint(
                equalTo: view.heightAnchor,
                multiplier: 0.33).isActive = true
        }
    }
    
    func createSceneView() {
        sceneView = ARSCNView(frame: view.bounds)
        
        sceneView.scene = SCNScene()
        sceneView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(sceneView, belowSubview: compass)
        
        sceneView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingSessionConfiguration()
        configuration.planeDetection = .horizontal
        
        sceneView.session.run(configuration)
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        if let source = style.source(withIdentifier: "composite") {
            let poiCircles = MGLCircleStyleLayer(identifier: "poi-circles", source: source)
            poiCircles.sourceLayerIdentifier = "poi_label"
            poiCircles.circleColor = MGLStyleValue(rawValue: .white)
            poiCircles.circleRadius = MGLStyleValue(rawValue: 4)
            style.addLayer(poiCircles)
        }
    }
}
