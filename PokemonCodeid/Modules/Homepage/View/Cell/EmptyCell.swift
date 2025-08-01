//
//  EmptyCell.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 01/08/25.
//

import UIKit

class EmptyCell: UITableViewCell {

    @IBOutlet weak var errorView: ErrorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureContentCell() {
        errorView.configureContent(with: .emptySearch)
    }
}
