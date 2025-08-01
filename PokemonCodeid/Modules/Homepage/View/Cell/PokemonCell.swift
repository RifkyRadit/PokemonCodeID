//
//  PokemonCell.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 31/07/25.
//

import UIKit

class PokemonCell: UITableViewCell {

    @IBOutlet weak var pokemonNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureContentCell(pokemonName: String) {
        pokemonNameLabel.text = pokemonName
    }
    
}
