//
//  ExtUIView.swift
//  iOStarter
//
//  Created by Crocodic Studio on 31/12/19.
//  Copyright © 2019 WahyuAdyP. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    /// Create tap gesture in view
    ///
    /// - Parameters:
    ///   - target: An object that is the recipient of action messages sent by the receiver when it recognizes a gesture. nil is not a valid value.
    ///   - action: A selector that identifies the method implemented by the target to handle the gesture recognized by the receiver. The action selector must conform to the signature described in the class overview. NULL is not a valid value.
    func setTapGesture(target: Any?, action: Selector?) {
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        tapGesture.numberOfTapsRequired = 1
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
    }
    
    /// Make view rounded with maximum radius
    func circle() {
        self.layoutIfNeeded()
        self.layer.cornerRadius = min(self.frame.size.width, self.frame.size.height) / 2
    }
    
    /// Make view rounded with specific radius value
    ///
    /// - Parameter value: Value of radius want rounded
    func rounded(value: CGFloat = 8) {
        self.layoutIfNeeded()
        self.layer.cornerRadius = value
    }
    
    /// Make shadow in view
    ///
    /// - Parameters:
    ///   - color: Color of shadow
    ///   - offset: Position of shadow in view
    func shadow(color: UIColor = UIColor.lightGray, offset: CGSize = CGSize(width: 0, height: 2.0)) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = 1.0
    }
    
    /// Remove shadow
    func removeShadow() {
        self.layer.shadowOpacity = 0.0
    }
    
    /// Make line border in view
    ///
    /// - Parameters:
    ///   - color: Color of border line
    ///   - width: Width of border line
    func border(color: UIColor = UIColor.black, width: CGFloat = 1) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    /// Make dashed border
    ///
    /// - Parameters:
    ///   - color: Color of dashed border
    ///   - width: Width of dashed border
    func dashedBorder(color: UIColor = UIColor.black, width: CGFloat = 1) {
        self.layoutIfNeeded()
        if let sublayers = layer.sublayers {
            for aLayer in sublayers {
                if aLayer.name == "dashedBorder" {
                    aLayer.removeFromSuperlayer()
                }
            }
        }
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.name = "dashedBorder"
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width / 2, y: frameSize.height / 2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = width
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6, 3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
        self.layer.addSublayer(shapeLayer)
    }
    
    /// Unlinks all view from its superview and its window, and removes all from the responder chain
    func removeAllSubviews() {
        for aView in subviews {
            aView.removeFromSuperview()
        }
    }
    
    /// Create background color gradient for view
    ///
    /// - Parameters:
    ///   - colors: Color of gradient layer
    ///   - direction: Direction of gradient layer
    func backgroundGradient(colors: [UIColor], direction: Direction = .top) {
        self.layoutIfNeeded()
        if let sublayers = layer.sublayers {
            for aLayer in sublayers {
                if aLayer.name == "gradientBG" {
                    aLayer.removeFromSuperlayer()
                }
            }
        }
        
        self.backgroundColor = colors.first
        let gradientLayer = CAGradientLayer(frame: bounds, colors: colors, direction: direction)
        gradientLayer.name = "gradientBG"
        gradientLayer.cornerRadius = self.layer.cornerRadius
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
