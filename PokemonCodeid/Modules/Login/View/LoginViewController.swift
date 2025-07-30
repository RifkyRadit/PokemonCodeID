//
//  LoginViewController.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 30/07/25.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginScrollView: UIScrollView!
    @IBOutlet weak var userNameField: CoreTextField!
    @IBOutlet weak var passwordField: CoreTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!
    
    var fieldsArr: [CoreTextField] = []
    var activeField: UITextField?
    var lastOffset: CGPoint?
    var keyboardHeight: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func setupView() {
        userNameField.configureCustomTextField(placeholderText: "Username")
        passwordField.configureCustomTextField(isPassowrdField: true, placeholderText: "Password")
        
        loginButton.layer.cornerRadius = 10
        loginButton.layer.masksToBounds = true
        
        setupRegisterText()
        
        fieldsArr = [userNameField, passwordField]
        fieldsArr.forEach { item in
            item.textField.delegate = self
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGestureScrollView = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardAction))
        loginScrollView.addGestureRecognizer(tapGestureScrollView)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupRegisterText() {
        let registerText = "Belum punya akun? Silahkan mendaftar"
        let attributedString = NSMutableAttributedString(string: registerText)
        let rangeOfRegister = (registerText as NSString).range(of: "mendaftar")
        
        let rangeOfNormalText = NSRange(location: 0, length: registerText.count)
        attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: rangeOfNormalText)
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 15) as Any, range: rangeOfNormalText)
        attributedString.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: rangeOfRegister)
        
        registerLabel.attributedText = attributedString
        registerLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLabelTap(_ :)))
        registerLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboardAction() {
        view.endEditing(true)
    }
    
    @objc private func handleLabelTap(_ gesture: UITapGestureRecognizer) {
        guard let label = gesture.view as? UILabel,
              let attributedText = label.attributedText else 
        {
            return
        }
        
        let tapLocation = gesture.location(in: label)
        
        let textContainer = NSTextContainer(size: label.bounds.size)
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)
        
        let textStorage = NSTextStorage(attributedString: attributedText)
        textStorage.addLayoutManager(layoutManager)
        
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textOffset = CGPoint(x: (label.bounds.size.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                 y: (label.bounds.size.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        
        let adjustedTapLocation = CGPoint(x: tapLocation.x - textOffset.x, y: tapLocation.y - textOffset.y)
        
        let glyphIndex = layoutManager.glyphIndex(for: adjustedTapLocation, in: textContainer)
        let characterIndex = layoutManager.characterIndexForGlyph(at: glyphIndex)
        
        if characterIndex >= attributedText.length {
            return
        }
        
        let fullText = (label.attributedText?.string ?? "") as NSString
        let rangeOfRegister = fullText.range(of: "mendaftar")
        
        if NSLocationInRange(characterIndex, rangeOfRegister) {
            print(">>> DEBUG register has tapped")
            let registerViewController = RegisterViewController()
            self.navigationController?.pushViewController(registerViewController, animated: true)
        } else {
            print(">>> DEBUG other text has tapped")
        }
    }

    @IBAction func loginButtonAction(_ sender: Any) {
        
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        lastOffset = self.loginScrollView.contentOffset
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activeField?.resignFirstResponder()
        activeField = nil
        return true
    }
}


extension LoginViewController {
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo, let keyboardHeight = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height else { return }

        loginScrollView.contentInset.bottom = keyboardHeight + 50
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        loginScrollView.contentInset.bottom = 0
    }
//    @objc func keyboardWillShow(notification: NSNotification) {
//        if keyboardHeight != nil {
//            return
//        }
//        
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            keyboardHeight = keyboardSize.height
//            
//            // so increase contentView's height by keyboard height
//            UIView.animate(withDuration: 0.3, animations: {
//                self.constraintContentHeight.constant += self.keyboardHeight ?? 0
//            })
//            
//            // move if keyboard hide input field
//            let distanceToBottom = self.loginScrollView.frame.size.height - (activeField?.frame.origin.y ?? 0) - (activeField?.frame.size.height ?? 0)
//            let collapseSpace = (keyboardHeight ?? 0) - distanceToBottom
//            
//            if collapseSpace < 0 {
//                // no collapse
//                return
//            }
//            
//            // set new offset for scroll view
//            UIView.animate(withDuration: 0.3, animations: {
//                // scroll to the position above keyboard 10 points
//                self.loginScrollView.contentOffset = CGPoint(x: self.lastOffset?.x ?? 0, y: collapseSpace + 10)
//            })
//        }
//    }
//    
//    @objc func keyboardWillHide(notification: NSNotification) {
//        UIView.animate(withDuration: 0.3) {
//            self.constraintContentHeight.constant -= self.keyboardHeight ?? 0.0
//            
//            self.loginScrollView.contentOffset = self.lastOffset ?? CGPoint()
//        }
//        
//        keyboardHeight = nil
//    }
}
