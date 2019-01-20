//
//  TinderCell.swift
//  Leksikon
//
//  Created by Владислав Форафонтов on 20/01/2019.
//  Copyright © 2019 Владислав Форафонтов. All rights reserved.
//

import UIKit

/** Класс ячейки в TinderWay */
class TinderCell {
    
    var view: UIView!
    
    /** Текущий scale ячейки. Установка этого значения реально визуально меняет scale view ячейки */
    var scale: CGFloat! {
        didSet {
            view.transform = CGAffineTransform(scaleX: scale, y: scale)
            
            currentScale = scale
        }
    }
    
    /** Промежуточный скейл ячейки, более текущей, чем scale. Они отличаются только в момент, когда ячейки нужно будет вернуться к нормальному scale */
    var currentScale: CGFloat! {
        didSet {
            view.transform = CGAffineTransform(scaleX: currentScale, y: currentScale)
        }
    }
    
    /** Центер ячейки. Установка этого значения реально визуально меняет center view ячейки */
    var center: CGPoint! {
        didSet {
            view.center = center
        }
    }
    
    /** Возвращает начальные размеры ячейки (без transform) */
    var nativeSize: CGSize {
        get {
            return view.frame.size
        }
    }
    
    /** Возвращает реальные размеры ячейки (с transform) */
    var scaleSize: CGSize {
        get {
            return CGSize(width: view.frame.width * scale, height: view.frame.height * scale)
        }
    }
    
    init(view: UIView, scale: CGFloat = 1.0) {
        self.view = view
        self.scale = scale
    }
    
}
