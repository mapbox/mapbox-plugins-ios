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
        view.addSubview(compass)
        
        createSceneView()
    }
    
    func createSceneView() {
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

