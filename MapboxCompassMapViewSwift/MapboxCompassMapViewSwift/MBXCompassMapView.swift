//
//  MBXCompassMapView.swift
//  MapboxCompassMapViewSwift
//
//  Created by Jordan Kiley on 7/19/17.
//  Copyright © 2017 Mapbox. All rights reserved.
//

import Mapbox

class MBXCompassMapView: MGLMapView, MGLMapViewDelegate, UIGestureRecognizerDelegate {
    
    private var mapRect : CGRect!
    private var mapCamera : MGLMapCamera!
    var isMapInteractive : Bool = true {
        didSet {
            
            // Disable individually, then add custom gesture recognizers as needed.
            self.isZoomEnabled = false
            self.isScrollEnabled = false
            self.isPitchEnabled = false
            self.isRotateEnabled = false
        }
    }
    
    var isEnlargeEnabled = false {
        didSet {
            let press = UILongPressGestureRecognizer(target: self, action: #selector(expandMapView(_:)))
            press.minimumPressDuration = 2
            self.addGestureRecognizer(press)
        }
    }
    
    override convenience init(frame: CGRect, styleURL: URL?) {
        self.init(frame: frame)
        self.styleURL = styleURL
    }
    
    // TODO: Clean up.
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        self.alpha = 0.8
        self.delegate = self
        mapRect = frame
        hideMapSubviews()
        
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        mapCamera = camera
    }
    
    override func layoutSubviews() {
        self.layer.cornerRadius = self.frame.width / 2
    }
    private func hideMapSubviews() {
        self.logoView.isHidden = true
        self.attributionButton.isHidden = true
        self.compassView.isHidden = true
    }
    
    @objc private func expandMapView(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .ended {
            if let superview = self.superview {
                if self.frame.width < superview.frame.width {
                    self.frame = superview.frame
                    self.layer.cornerRadius = superview.layer.cornerRadius
                    self.reloadStyle(self)
                } else {
                    self.frame = mapRect
                }
            }
        }
    }
    
    func mapViewWillStartLoadingMap(_ mapView: MGLMapView) {
        self.userTrackingMode = .followWithHeading
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setMapViewBorderColorAndWidth(color: CGColor, width: CGFloat) {
        self.layer.borderWidth = width
        self.layer.borderColor = color
    }
}

extension MBXCompassMapView {
    func setupUserTrackingMode() {
        self.showsUserLocation = true
        self.setUserTrackingMode(.followWithHeading, animated: false)
        self.displayHeadingCalibration = false
    }
}
