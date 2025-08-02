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
    private var shouldSetupPassword = false
    private var isPasswordField = false
    
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
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.masksToBounds = true
    }
    
    func configureCustomTextField(isPassowrdField: Bool = false, placeholderText: String) {
        showPasswordButton.setImage(UIImage(named: "icon_hide_password"), for: .normal)
        showPasswordButton.isHidden = !isPassowrdField
        textField.autocorrectionType = .no
        textField.textContentType = .oneTimeCode
        textField.isSecureTextEntry = isPassowrdField
        
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [.foregroundColor: UIColor.black])
    }
    
    @IBAction func showPasswordButtonAction(_ sender: Any) {
        isPasswordHiding.toggle()
        showPasswordButton.setImage(UIImage(named: isPasswordHiding ? "icon_hide_password" : "icon_show_password"), for: .normal)
        textField.isSecureTextEntry = isPasswordHiding
    }
}
