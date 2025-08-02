//
//  MainTabViewController.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 31/07/25.
//

import UIKit
import XLPagerTabStrip

class MainTabViewController: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureButtonBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Pokemon"
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        buttonBarView.frame.origin.y = 100
        containerView.frame.origin.y = buttonBarView.frame.maxY
        containerView.frame.size.height = view.frame.height - containerView.frame.origin.y
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child1 = HomepageViewController()
        let child2 = ProfileViewController()
        return [child1, child2]
    }
    
    // MARK: - Configuration
    func configureButtonBar() {
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        
        settings.style.buttonBarItemFont = UIFont(name: "Helvetica", size: 16.0)!
        settings.style.buttonBarItemTitleColor = .yellow
        
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        settings.style.selectedBarHeight = 3.0
        buttonBarView.backgroundColor = .white
        buttonBarView.selectedBar.backgroundColor = UIColor(named: "color_main_red")
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .black
            newCell?.label.textColor = UIColor(named: "color_main_red")
        }
    }
}
