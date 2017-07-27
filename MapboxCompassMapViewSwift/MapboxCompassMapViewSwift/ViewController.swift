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
        compass = MBXCompassMapView(frame: CGRect(x: view.bounds.width * 2/3 - 20,
                                                  y: 20,
                                                  width: view.bounds.width / 3,
                                                  height: view.bounds.width / 3),
                                    styleURL: URL(string: "mapbox://styles/jordankiley/cj5eeueie1bsa2rp4swgcteml"))
        //
        //        compass.setMapViewBorderColorAndWidth(color: UIColor.black.cgColor,
        //                                              width: 1)
        //
        compass.isMapInteractive = false
        compass.tintColor = .black
        compass.isEnlargeEnabled = true
        view.addSubview(compass)
        createSceneView()
        
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
