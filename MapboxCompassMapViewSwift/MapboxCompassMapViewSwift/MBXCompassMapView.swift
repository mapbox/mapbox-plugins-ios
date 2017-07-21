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
    var arrow : CustomArrow!
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required convenience init(frame: CGRect, styleURL: URL?, withArrow: Bool) {
        self.init(frame: frame)
        //        self.backgroundColor = UIColor.blue
        self.autoresizingMask = [.flexibleBottomMargin]
        if withArrow {
            arrow = CustomArrow(size: frame.width)
            arrow.backgroundColor = UIColor.gray.cgColor
            mapView.layer.addSublayer(arrow)
        }
        
        let mapViewFrame = CGRect(x: frame.width / 10, y: frame.width / 10, width: frame.width * 0.8, height: frame.height * 0.8)
        mapView = MBXMapView(frame: mapViewFrame, styleURL: styleURL)
        mapView.delegate = self
        
        self.addSubview(mapView)
    }
    
    // Set the position of the compass by using an enum. Want to implement an option for compass size as well.
    convenience init(position: compassPosition, inView: UIView, styleURL: URL?, withArrow: Bool) {
        switch position {
        case .topLeft:
            self.init(frame: CGRect(x: 20, y: 20, width: inView.bounds.width / 3, height: inView.bounds.width / 3), styleURL: styleURL, withArrow: withArrow)
        case .topRight:
            self.init(frame: CGRect(x: inView.bounds.width * 2/3, y: 20, width: inView.bounds.width / 3, height: inView.bounds.width / 3), styleURL: styleURL, withArrow: withArrow)
        case .bottomRight:
            print("bottomRight")
            self.init(frame: CGRect(x: inView.bounds.width * 2/3, y: inView.bounds.height - (inView.bounds.width * 1/3) - 20, width: inView.bounds.width / 3, height: inView.bounds.width / 3), styleURL: styleURL, withArrow: withArrow)

        case .bottomLeft:
            print("bottomLeft")
            self.init(frame: CGRect(x: 20, y: inView.bounds.height - (inView.bounds.width * 1/3) - 20, width: inView.bounds.width / 3, height: inView.bounds.width / 3), styleURL: styleURL, withArrow: withArrow)

        default:
            print("center")
            self.init(frame: CGRect(x: (inView.bounds.width / 2) - (inView.bounds.width / 6), y: (inView.bounds.height / 2) - (inView.bounds.width / 6), width: inView.bounds.width / 3, height: inView.bounds.width / 3), styleURL: styleURL, withArrow: withArrow)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
        print(mapView.direction)
        if userLocation?.heading != nil && arrow != nil {
            let rotation = CGAffineTransform.identity.rotated(
                by: -MGLRadiansFromDegrees(mapView.direction -  (userLocation?.heading!.trueHeading)!))
            arrow.setAffineTransform(rotation)
        }
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
        self.autoresizingMask = [.flexibleBottomMargin]
        //        self.alpha = 0.5
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
    
    func setBorderColorAndWidth(color: CGColor, width: CGFloat) {
        self.layer.borderWidth = width
        self.layer.borderColor = color
    }
}

// code from the custom user annotation example
class CustomArrow: CAShapeLayer {
    var size : CGFloat!
    var arrowSize : CGFloat!
    
    convenience init(size: CGFloat) {
        self.init()
        self.size = size
        setupArrow()
    }
    
    private func setupArrow() {
        arrowSize = size / 2.5
        self.path = arrowPath()
        self.frame = CGRect(x: 0, y: 0, width: arrowSize, height: arrowSize)
        self.position = CGPoint(x: size / 2, y: size / -4.5)
    }
    
    private func arrowPath() -> CGPath {
        // Draw an arrow.
        
        let max: CGFloat = arrowSize
        
        let top = CGPoint(x: max * 0.5, y: max * 0.4)
        let left = CGPoint(x: 0, y: max)
        let right = CGPoint(x: max, y: max)
        let center = CGPoint(x: max * 0.5, y: max * 0.8)
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: top)
        bezierPath.addLine(to: left)
        bezierPath.addQuadCurve(to: right, controlPoint: center)
        bezierPath.addLine(to: top)
        bezierPath.close()
        return bezierPath.cgPath
    }
}
