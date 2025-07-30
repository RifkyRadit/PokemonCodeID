//
//  Utility.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 30/07/25.
//

import UIKit

func showErrorAlert(errorMessage: String) -> UIAlertController {
    let alert = UIAlertController(title: "", message: errorMessage, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
    return alert
}
