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
        compass = MBXCompassMapView(position: .topRight,
                                    inView: view,
                                    styleURL: URL(string: "mapbox://styles/jordankiley/cj5eeueie1bsa2rp4swgcteml"))
        //
        //        compass.setMapViewBorderColorAndWidth(color: UIColor.black.cgColor,
        //                                              width: 1)
        //
        compass.tintColor = .black
        
        view.addSubview(compass)
        createSceneView()
        setConstraints()
    }
    
    func createSceneView() {
        sceneView = ARSCNView(frame: view.bounds)
        
        sceneView.scene = SCNScene()
        sceneView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(sceneView, belowSubview: compass)
        
        sceneView.delegate = self
        //        addAnchors()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingSessionConfiguration()
        configuration.planeDetection = .horizontal
        
        sceneView.session.run(configuration)
    }
    
    func setConstraints() {
        compass.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        compass.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        compass.translatesAutoresizingMaskIntoConstraints = false
        if view.frame.width < view.frame.height {
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
    //        func addAnchors() {
    ////            let attributes : [NSLayoutAttribute] = [.top, .right]
    ////            NSLayoutConstraint.activate(attributes.map {
    ////                NSLayoutConstraint(item: compass, attribute: $0, relatedBy: .equal, toItem: sceneView, attribute: $0, multiplier: 1, constant: 0)
    ////            })
    //            let margins = sceneView.layoutMarginsGuide
    ////            compass.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
    ////            compass.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
    //            compass.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
    //
    //        }
    
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

