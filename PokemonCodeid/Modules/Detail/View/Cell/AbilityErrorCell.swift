//
//  AbilityErrorCell.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 01/08/25.
//

import UIKit

class AbilityErrorCell: UICollectionViewCell {

    @IBOutlet weak var errorView: ErrorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureContentCell(state: ErrorState) {
        errorView.configureContent(with: state)
    }
}
