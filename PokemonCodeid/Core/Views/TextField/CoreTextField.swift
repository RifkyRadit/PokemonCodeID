//
//  CoreTextField.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 30/07/25.
//

import UIKit

class CoreTextField: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var showPasswordButton: UIButton!
    
    private var isPasswordHiding: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        setupView()
    }
    
    fileprivate func commonInit() {
        Bundle.main.loadNibNamed(String(describing: CoreTextField.self), owner: self, options: nil)
        
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func setupView() {
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 3
        contentView.layer.borderColor = UIColor(named: "color_gray")?.cgColor
        contentView.layer.masksToBounds = true
    }
    
    func configureCustomTextField(isPassowrdField: Bool = false, placeholderText: String) {
        showPasswordButton.setImage(UIImage(named: "icon_show_password"), for: .normal)
        showPasswordButton.isHidden = !isPassowrdField
        textField.isSecureTextEntry = isPassowrdField
        textField.placeholder = placeholderText
    }
    
    @IBAction func showPasswordButtonAction(_ sender: Any) {
        if isPasswordHiding {
            showPasswordButton.setImage(UIImage(named: "icon_hide_password"), for: .normal)
            textField.isSecureTextEntry = false
            isPasswordHiding = false
        } else {
            showPasswordButton.setImage(UIImage(named: "icon_show_password"), for: .normal)
            textField.isSecureTextEntry = true
            isPasswordHiding = true
        }
    }
}
