//
//  AbilityItemCell.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 01/08/25.
//

import UIKit

class AbilityItemCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var abilityNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }

    private func setupView() {
        containerView.layer.cornerRadius = 18
        containerView.layer.masksToBounds = true
    }
    
    func configureContentCell(ability: Ability?) {
        guard let ability = ability, !ability.name.isEmpty else {
            return
        }
        
        abilityNameLabel.text = ability.name
    }
}
