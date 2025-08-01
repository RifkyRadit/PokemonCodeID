//
//  ProfileViewController.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 31/07/25.
//

import UIKit
import XLPagerTabStrip
import MBProgressHUD
import RxSwift

class ProfileViewController: UIViewController, IndicatorInfoProvider {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var usernameValueLabel: UILabel!
    @IBOutlet weak var emailValueLabel: UILabel!
    
    private(set) var viewModel = ProfileViewModel()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        viewModel.viewDidLoad()
    }

    func indicatorInfo(for pagerTabStripController: XLPagerTabStrip.PagerTabStripViewController) -> XLPagerTabStrip.IndicatorInfo {
        return IndicatorInfo(title: "Profile")
    }
    
    private func bindViewModel() {
        viewModel.outputs.state
            .subscribe(onNext: { [weak self] resultState in
                guard let self, let state = resultState else { return }
                self.configureState(state)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureState(_ state: ProfileViewState) {
        switch state {
        case .loading:
            containerView.isHidden = true
            let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
            progressHUD.label.text = "Loading...."
            
        case .showContent(let dataProfile):
            containerView.isHidden = false
            MBProgressHUD.hide(for: self.view, animated: true)
            usernameValueLabel.text = dataProfile.username
            emailValueLabel.text = dataProfile.email
        }
    }
}
