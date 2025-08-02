//
//  UIViewController+Extension.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 01/08/25.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedArround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
