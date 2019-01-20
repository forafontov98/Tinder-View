//
//  ViewController.swift
//  Leksikon
//
//  Created by Владислав Форафонтов on 18/01/2019.
//  Copyright © 2019 Владислав Форафонтов. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tinderView: TinderWay!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tinderView.dataSource = self
        tinderView.delegate = self
        
    }
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
        
    }
    
    
    @IBAction func rejectBtnPressed(_ sender: Any) {
        tinderView.toLeft()
    }
    
    
    @IBAction func favouriteBtnPressed(_ sender: Any) {
        if let card = tinderView.currentCard() {
            if let view = card.view as? LearningCardView {
                view.favourite(true)
            }
        }
    }
    
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        tinderView.toRight()
    }
    
    
    @IBAction func autoBtnPressed(_ sender: Any) {
        
    }
}


extension ViewController: TinderWayDataSource {
    func numberOfItems() -> Int {
        return 30
    }
    
    func cell(_ id: Int) -> UIView {
        let view = LearningCardView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width - 40.0, height: 250.0))
        view.label.text = "\(id)"
        
        return view
    }
}


extension ViewController: TinderWayDelegate {
    func toRight(card: TinderCell) {
        
        if let view = card.view as? LearningCardView {
            UIView.animate(withDuration: 0.1) {
                view.doneImageView.alpha = 1.0
            }
        }
    }
    
    func toLeft(card: TinderCell) {
        
        if let view = card.view as? LearningCardView {
            UIView.animate(withDuration: 0.1) {
                view.rejectImageView.alpha = 1.0
            }
        }
    }
    
    func toCenter(card: TinderCell) {
        if let view = card.view as? LearningCardView {
            UIView.animate(withDuration: 0.1) {
                view.doneImageView.alpha = 0.0
                view.rejectImageView.alpha = 0.0
            }
        }
    }
    
    func doubleTapped(card: TinderCell) {
        if let view = card.view as? LearningCardView {
            view.favourite(true)
        }
    }
    
    func motion(card: TinderCell, offset: CGPoint) {
        
        if offset.x > 0 {
           
            if let view = card.view as? LearningCardView {
                view.doneImageView.alpha = abs(offset.x) / 150.0
            }
            
        } else {
            
            if let view = card.view as? LearningCardView {
                view.rejectImageView.alpha = abs(offset.x) / 150.0
            }
            
        }
    }
    
    
}
