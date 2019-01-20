//
//  LearningCardView.swift
//  Leksikon
//
//  Created by Владислав Форафонтов on 21/01/2019.
//  Copyright © 2019 Владислав Форафонтов. All rights reserved.
//

import UIKit

class LearningCardView: UIView {
    private var view: BaseView!
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var favouriteIcon: UIImageView!
    @IBOutlet weak var doneImageView: UIImageView!
    @IBOutlet weak var rejectImageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setup() {
        view = loadFromNib()
        view.frame = bounds
        
        view.backgroundColor = .clear
        
        addSubview(view)
    }
    
    private func loadFromNib() -> BaseView {
        let bundle = Bundle(for: self.classForCoder)
        let nib = UINib(nibName: "LearningCardView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! BaseView
        
        return view
    }
    
    func favourite(_ val: Bool) {
        if val {
            favouriteIcon.image = UIImage(named: "star")
        } else {
            favouriteIcon.image = UIImage(named: "starOff")
        }
    }
}
