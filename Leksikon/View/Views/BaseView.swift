//
//  BaseView.swift
//  Leksikon
//
//  Created by Владислав Форафонтов on 18/01/2019.
//  Copyright © 2019 Владислав Форафонтов. All rights reserved.
//

import UIKit

/** Базовое view, от которого наследуются все последующие view приложения.
Имеет тень и скругленные углы (radius = 8) */
@IBDesignable
class BaseView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 8.0
    @IBInspectable var color: UIColor = .white {
        didSet {
            shadowLayer.fillColor = color.cgColor
        }
    }
    
    private var shadowLayer: CAShapeLayer!
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            shadowLayer.fillColor = color.cgColor
            
            shadowLayer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08).cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            shadowLayer.shadowOpacity = 1.0
            shadowLayer.shadowRadius = 7
            
            layer.insertSublayer(shadowLayer, at: 0)
        }
                
    }
}
