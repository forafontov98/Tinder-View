//
//  TabBarController.swift
//  Leksikon
//
//  Created by Владислав Форафонтов on 18/01/2019.
//  Copyright © 2019 Владислав Форафонтов. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
                
        if let tabBar = tabBar as? MainTabBar {
            tabBar.itemPressed(selectedIndex)
            tabBar._delegate = self
        }
    }
}

extension TabBarController: MainTabBarDelegate {
    func itemPressed(index: Int) {
        selectedIndex = index
    }
}
