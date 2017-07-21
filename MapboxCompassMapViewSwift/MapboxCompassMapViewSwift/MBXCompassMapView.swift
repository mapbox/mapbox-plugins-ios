//
//  MBXCompassMapView.swift
//  MapboxCompassMapViewSwift
//
//  Created by Jordan Kiley on 7/19/17.
//  Copyright © 2017 Mapbox. All rights reserved.
//

import Mapbox

class MBXCompassMapView: UIView, MGLMapViewDelegate {
    
    var mapView : MBXMapView!
    
    // Initializer that creates a basic map view.
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    // Initializer that allows user to create a custom map view frame.
    required convenience init(frame: CGRect, styleURL: URL?) {
        self.init(frame: frame)
        //        self.backgroundColor = UIColor.blue
        self.autoresizingMask = [.flexibleBottomMargin]
        
        
        let mapViewFrame = CGRect(x: frame.width / 10,
                                  y: frame.width / 10,
                                  width: frame.width * 0.7,
                                  height: frame.height * 0.7)
        mapView = MBXMapView(frame: mapViewFrame, styleURL: styleURL)
        mapView.delegate = self
        
        // Create an arrow if true.
        
        self.addSubview(mapView)
    }
    
    // Set the position of the compass by using an enum. Want to implement an option for compass size as well.
    convenience init(position: compassPosition, inView: UIView, styleURL: URL?) {
        switch position {
            
        case .topLeft:
            self.init(frame: CGRect(x: 20,
                                    y: 20,
                                    width: inView.bounds.width / 3,
                                    height: inView.bounds.width / 3),
                      styleURL: styleURL)
            
        case .topRight:
            self.init(frame: CGRect(x: inView.bounds.width * 2/3,
                                    y: 20,
                                    width: inView.bounds.width / 3,
                                    height: inView.bounds.width / 3),
                      styleURL: styleURL)
            
        case .bottomRight:
            print("bottomRight")
            self.init(frame: CGRect(x: inView.bounds.width * 2/3,
                                    y: inView.bounds.height - (inView.bounds.width * 1/3) - 20,
                                    width: inView.bounds.width / 3,
                                    height: inView.bounds.width / 3),
                      styleURL: styleURL)
            
        case .bottomLeft:
            print("bottomLeft")
            self.init(frame: CGRect(x: 20,
                                    y: inView.bounds.height - (inView.bounds.width * 1/3) - 20,
                                    width: inView.bounds.width / 3,
                                    height: inView.bounds.width / 3),
                      styleURL: styleURL)
            
        default:
            print("center")
            self.init(frame: CGRect(x: (inView.bounds.width / 2) - (inView.bounds.width / 6),
                                    y: (inView.bounds.height / 2) - (inView.bounds.width / 6),
                                    width: inView.bounds.width / 3,
                                    height: inView.bounds.width / 3),
                      styleURL: styleURL)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setMapViewBorderColorAndWidth(color: CGColor, width: CGFloat) {
        mapView.layer.borderWidth = width
        mapView.layer.borderColor = color
//        mapView.layer.borderColor?.alpha = 0.3
        
        
    }
    
    enum compassPosition {
        case topLeft
        case topRight
        case bottomRight
        case bottomLeft
        case center
    }
    
}

class MBXMapView: MGLMapView, MGLMapViewDelegate {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        self.layer.cornerRadius = self.frame.width / 2
        self.logoView.isHidden = true
        self.attributionButton.isHidden = true
        self.compassView.isHidden = true
        self.isUserInteractionEnabled = false
        self.autoresizingMask = [.flexibleBottomMargin]
        self.alpha = 0.8
        self.tintColor = .black
        
    }
    
    func mapViewWillStartLoadingMap(_ mapView: MGLMapView) {
        self.userTrackingMode = .followWithHeading
    }
    
    override convenience init(frame: CGRect, styleURL: URL?) {
        self.init(frame: frame)
        self.styleURL = styleURL
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MBXMapView {
    func setupUserTrackingMode() {
        self.showsUserLocation = true
        self.setUserTrackingMode(.followWithHeading, animated: false)
        self.displayHeadingCalibration = false
    }
    
    func mapView(_ mapView: MGLMapView, didChange mode: MGLUserTrackingMode, animated: Bool) {
        if mode != .followWithHeading {
            self.userTrackingMode = .followWithHeading
        }
    }
    
    
}
