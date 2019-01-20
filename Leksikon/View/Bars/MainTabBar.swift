//
//  MainTabBar.swift
//  Leksikon
//
//  Created by Владислав Форафонтов on 18/01/2019.
//  Copyright © 2019 Владислав Форафонтов. All rights reserved.
//

import UIKit

protocol MainTabBarDelegate {
    func itemPressed(index: Int)
}

/** Класс нижнего UITabBar всего приложения. Здесь реализуется кастомное поведение кнопок */
class MainTabBar: UITabBar {

    /** Названия изображений иконок в невыбранном состоянии */
    private var offIcons = ["wordsIconOff", "repeatingIconOff", "statIconOff", "accountIconOff"]
    
    /** Названия изображений иконок в выбранном состоянии */
    private var onIcons = ["wordsIconOn", "repeatingIconOn", "statIconOn", "accountIconOn"]
    
    /** Массив кнопок нижней панели */
    private var buttons: [UIButton] = []
    
    var _delegate: MainTabBarDelegate?
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {

        let itemWidth = UIScreen.main.bounds.width / CGFloat(offIcons.count)
        let itemHeight = frame.size.height

        buttons.removeAll()
        
        for (index, iconName) in offIcons.enumerated() {
            
            let button = UIButton()
            button.frame = CGRect(x: itemWidth * CGFloat(index), y: 0, width: itemWidth, height: itemHeight)
            button.setImage(UIImage(named: iconName), for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
            button.backgroundColor = .clear
            button.addTarget(self, action: #selector(itemPressed(sender:)), for: .touchUpInside)
            button.adjustsImageWhenHighlighted = false
            
            buttons.append(button)
            
            addSubview(button)
        }

    }
    
    /** Action нажатия на кнопку sender нижней панели */
    @objc func itemPressed(sender: UIButton) {
        
        for (index, button) in buttons.enumerated() {
            
            if button == sender {
                _delegate?.itemPressed(index: index)
            
                UIView.animate(withDuration: 0.1, animations: {
                    button.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    button.setImage(UIImage(named: self.onIcons[index]), for: .normal)

                }) { (_) in
                    
                    UIView.animate(withDuration: 0.1, animations: {
                        button.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                        
                    }, completion: { (_) in
                        UIView.animate(withDuration: 0.1) {
                            button.transform = CGAffineTransform.identity
                        }
                    })
                    
                }
                
            } else {
                button.setImage(UIImage(named: offIcons[index]), for: .normal)
            }
        }
    }
    
    /** Вызывается, когда необходимо отметить кнопку с индексом id отмеченной */
    func itemPressed(_ id: Int) {
        for (index, button) in buttons.enumerated() {
            
            if index == id {
                button.setImage(UIImage(named: onIcons[index]), for: .normal)
                _delegate?.itemPressed(index: index)
                
            } else {
                button.setImage(UIImage(named: offIcons[index]), for: .normal)
            }
        }
    }
}
