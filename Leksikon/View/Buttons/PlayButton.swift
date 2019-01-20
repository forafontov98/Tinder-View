//
//  PlayButton.swift
//  Leksikon
//
//  Created by Владислав Форафонтов on 18/01/2019.
//  Copyright © 2019 Владислав Форафонтов. All rights reserved.
//

import UIKit

/** Класс круглых кастомных кнопок с тенью и иконкой внутри
Используется на экранах изучения слов (например, нравится слово, пропустить слово, автогенерация слов, добавить в избранное, назад) */
@IBDesignable
class PlayButton: UIButton {
    
    /** Название иконки кнопки */
    @IBInspectable var imageName: String = "done"
    
    /** Цвет круга */
    @IBInspectable var bgColor: UIColor = .white
    
    /** Layer круга кнопки */
    private var shapeLayer = CAShapeLayer()
    
    
    /** На этот параметр умножаются размеры кнопки при нажатии */
    private var touchScale: CGFloat = 0.85
    
    
    /** Path круга кнопки */
    private var circlePath: UIBezierPath {
        get {
            return UIBezierPath(arcCenter: CGPoint(x: bounds.width / 2, y: bounds.height / 2),
                                radius: bounds.width / 2,
                                startAngle: 0.0,
                                endAngle: CGFloat(Double.pi * 2),
                                clockwise: true)
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        shadowConfig()
        
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = bgColor.cgColor

        layer.addSublayer(shapeLayer)
        
        iconConfig()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform(scaleX: self.touchScale, y: self.touchScale)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 1.02, y: 1.02)

        }) { (_) in
            
            UIView.animate(withDuration: 0.1, animations: {
                self.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)

            }, completion: { (_) in
                UIView.animate(withDuration: 0.1) {
                    self.transform = CGAffineTransform.identity
                }
            })
            
        }
    }
    
    /** Установка тени кнопки */
    private func shadowConfig() {
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08).cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 4.0
        layer.masksToBounds = false
    }
    
    /** Установка иконки кнопки */
    private func iconConfig() {
        let icon = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: bounds.width / 2, height: bounds.width / 2))
        icon.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        icon.image = UIImage(named: imageName)
        icon.contentMode = .scaleAspectFit
        
        addSubview(icon)
    }
}
