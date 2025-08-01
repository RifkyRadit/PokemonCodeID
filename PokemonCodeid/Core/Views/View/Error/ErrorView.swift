//
//  ErrorView.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 01/08/25.
//

import UIKit

protocol ErrorStateViewDelegate: AnyObject {
    func didTapRetryButton()
}

class ErrorView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    
    weak var delegate: ErrorStateViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    fileprivate func commonInit() {
        Bundle.main.loadNibNamed(String(describing: ErrorView.self), owner: self, options: nil)
        
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        descriptionLabel.preferredMaxLayoutWidth = descriptionLabel.frame.width
    }
    
    func configureContent(with errorState: ErrorState) {
        iconImageView.image = UIImage(named: errorState.iconImage)
        titleLabel.text = errorState.titleText
        descriptionLabel.text = errorState.descriptionText
        
        retryButton.setTitle("Coba Lagi", for: .normal)
        retryButton.addTarget(self, action: #selector(retryButtonAction), for: .touchUpInside)
        retryButton.layer.cornerRadius = retryButton.frame.height / 2
        retryButton.layer.masksToBounds = true
        
        switch errorState {
        case .generalError, .noConnection, .emptyPokemonList:
            retryButton.isHidden = false
        case .emptyAbility, .emptySearch:
            retryButton.isHidden = true
        }
        
        self.layoutIfNeeded()
    }
    
    @IBAction func retryButtonAction(_ sender: Any) {
        delegate?.didTapRetryButton()
    }
}
