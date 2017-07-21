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
        
        compass = MBXCompassMapView(position: .topRight, inView: view, styleURL: URL(string: "mapbox://styles/jordankiley/cj5bj9vn37uh82rnuezu0bk3y"), withArrow: false)
//            MBXCompassMapView(frame: CGRect(x: 20, y: 20, width: view.bounds.width / 3, height: view.bounds.width / 3), styleURL: URL(string: "mapbox://styles/jordankiley/cj5bj9vn37uh82rnuezu0bk3y"), withArrow: false)
        compass.mapView.setBorderColorAndWidth(color: UIColor.red.cgColor, width: 5)
        view.addSubview(compass)
        
        sceneView = ARSCNView(frame: view.bounds)
        sceneView.delegate = self
        sceneView.scene = SCNScene()
        sceneView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(sceneView, belowSubview: compass)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingSessionConfiguration()
        configuration.planeDetection = .horizontal
        
        sceneView.session.run(configuration)
    }
}

