//
//  MBXCompassMapView.swift
//  MapboxCompassMapViewSwift
//
//  Created by Jordan Kiley on 7/19/17.
//  Copyright © 2017 Mapbox. All rights reserved.
//

import Mapbox

class MBXCompassMapView: MGLMapView, MGLMapViewDelegate, UIGestureRecognizerDelegate {
    
    var position : compassPosition?
    var isMapInteractive : Bool = true {
        didSet {
            // Disabling individually to test implementing custom zoom.
            self.isZoomEnabled = false
            self.isScrollEnabled = false
            self.isPitchEnabled = false
            self.isRotateEnabled = false
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
    }
    
    override func layoutSubviews() {
        self.layer.cornerRadius = self.frame.width / 2
    }
    
    private func hideMapSubviews() {
        self.logoView.isHidden = true
        self.attributionButton.isHidden = true
        self.compassView.isHidden = true
    }
    
    // TODO: Variables for values? Add size options (small, medium, large?)
    convenience init(position: compassPosition, inView: UIView, styleURL: URL?) {
        let baseAmount : CGFloat
        if inView.bounds.width < inView.bounds.height {
            baseAmount = inView.bounds.width
        } else {
            baseAmount = inView.bounds.height
        }
        
        // Is this necessary? Can I set this through constraints instead?
        switch position {
        case .topLeft:
            self.init(frame: CGRect(x: 20,
                                    y: 20,
                                    width: baseAmount / 3,
                                    height: baseAmount / 3),
                      styleURL: styleURL)
            
        case .topRight:
            self.init(frame: CGRect(x: baseAmount * 2/3 - 20,
                                    y: 20,
                                    width: baseAmount / 3,
                                    height: baseAmount / 3),
                      styleURL: styleURL)
            
            
        case .bottomRight:
            self.init(frame: CGRect(x: inView.bounds.width * 2/3,
                                    y: inView.bounds.height - (inView.bounds.width * 1/3) - 20,
                                    width: inView.bounds.width / 3,
                                    height: inView.bounds.width / 3),
                      styleURL: styleURL)
            
        case .bottomLeft:
            self.init(frame: CGRect(x: 20,
                                    y: inView.bounds.height - (inView.bounds.width * 1/3) - 20,
                                    width: inView.bounds.width / 3,
                                    height: inView.bounds.width / 3),
                      styleURL: styleURL)
            
        default:
            self.init(frame: CGRect(x: (inView.bounds.width / 2) - (inView.bounds.width / 6),
                                    y: (inView.bounds.height / 2) - (inView.bounds.width / 6),
                                    width: inView.bounds.width / 3,
                                    height: inView.bounds.width / 3),
                      styleURL: styleURL)
        }
        self.position = position
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
    
    enum compassPosition {
        case topLeft
        case topRight
        case bottomRight
        case bottomLeft
        case center
    }
}

extension MBXCompassMapView {
    func setupUserTrackingMode() {
        self.showsUserLocation = true
        self.setUserTrackingMode(.followWithHeading, animated: false)
        self.displayHeadingCalibration = false
    }
}
