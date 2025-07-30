//
//  RegisterViewController.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 30/07/25.
//

import UIKit
import RxSwift
import RealmSwift

class RegisterViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var usernameField: CoreTextField!
    @IBOutlet weak var emailField: CoreTextField!
    @IBOutlet weak var passwordField: CoreTextField!
    @IBOutlet weak var confirmPasswordField: CoreTextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var LoginText: UILabel!
    
    private(set) var viewModel = RegisterViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("📂 Realm file path: \(Realm.Configuration.defaultConfiguration.fileURL?.path ?? "Not found")")
        setupView()
        bindViewModel()
//        registerKeyboardListener()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func setupView() {
        usernameField.configureCustomTextField(placeholderText: "Username")
        emailField.configureCustomTextField(placeholderText: "Email")
        passwordField.configureCustomTextField(isPassowrdField: true, placeholderText: "Password")
        confirmPasswordField.configureCustomTextField(isPassowrdField: true, placeholderText: "Konfirmasi Password")
        
        registerButton.layer.cornerRadius = 10
        registerButton.layer.masksToBounds = true
        registerButton.isEnabled = false
        registerButton.backgroundColor = UIColor(named: "color_gray")
        
        setupRegisterText()
        
        [usernameField, emailField, passwordField, confirmPasswordField].forEach {
            $0?.textField.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func bindViewModel() {
        viewModel.outputs.state
            .subscribe(onNext: { [weak self] resultState in
                guard let self, let state = resultState else { return }
                self.configureState(state: state)
            })
            .disposed(by: disposeBag)
    }
    
    @objc private func textFieldsDidChange() {
        let isFormFilled = !(usernameField.textField.text?.isEmpty ?? true) &&
                           !(emailField.textField.text?.isEmpty ?? true) &&
                           !(passwordField.textField.text?.isEmpty ?? true) &&
                           !(confirmPasswordField.textField.text?.isEmpty ?? true)
        registerButton.isEnabled = isFormFilled
        registerButton.backgroundColor = isFormFilled ? UIColor(named: "color_main_red") : UIColor(named: "color_gray")
    }
    
    

    @IBAction func registerButtonAction(_ sender: Any) {
        let usernameText = usernameField.textField.text ?? ""
        let emailText = emailField.textField.text ?? ""
        let passwordText = passwordField.textField.text ?? ""
        let confirmPasswordText = confirmPasswordField.textField.text ?? ""
        
        viewModel.registerNewUser(email: emailText, username: usernameText, password: passwordText, confirmPassword: confirmPasswordText)
    }
}

// MARK: - Keyboard Listener
extension RegisterViewController {
    private func registerKeyboardListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGestureContentView = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardAction))
        contentView.addGestureRecognizer(tapGestureContentView)
    }
    
    private func setupRegisterText() {
        let registerText = "Sudah punya akun? Silahkan masuk"
        let attributedString = NSMutableAttributedString(string: registerText)
        let rangeOfRegister = (registerText as NSString).range(of: "masuk")
        
        let rangeOfNormalText = NSRange(location: 0, length: registerText.count)
        attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: rangeOfNormalText)
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 15) as Any, range: rangeOfNormalText)
        attributedString.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: rangeOfRegister)
        
        LoginText.attributedText = attributedString
        LoginText.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLabelTap(_ :)))
        LoginText.addGestureRecognizer(tapGesture)
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
        let rangeOfRegister = fullText.range(of: "masuk")
        
        if NSLocationInRange(characterIndex, rangeOfRegister) {
            print(">>> DEBUG login has tapped")
            self.navigationController?.popViewController(animated: true)
        } else {
            print(">>> DEBUG other text has tapped")
        }
    }
    
    @objc func dismissKeyboardAction() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo, let keyboardHeight = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height else { return }
        
        self.contentView.frame.origin.y = -keyboardHeight + 50
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        self.contentView.frame.origin.y = 0
    }
}

// MARK: - State Registration
extension RegisterViewController {
    private func configureState(state: RegisterViewState) {
        switch state {
        case .successRegistration:
            let alert = UIAlertController(title: "", message: "Registrasi berhasil. Silahkan untuk masuk kembali", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OKE", style: .default, handler: { [weak self] _ in
                guard let self else {
                    return
                }
                
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true)
        case .failedRegistration:
            let errorAlert = showErrorAlert(errorMessage: "Registrasi Gagal. Silahkan coba kembali beberapa saat lagi")
            self.present(errorAlert, animated: true)
        case .invalidData(let state):
            configureInvalidDataRegistration(state: state)
        }
    }
    
    private func configureInvalidDataRegistration(state: RegisterValidationState) {
        switch state {
        case .success:
            break
        case .usernameAlready:
            let errorAlert = showErrorAlert(errorMessage: "Registrasi Gagal. Username telah digunakan")
            self.present(errorAlert, animated: true)
            
        case .emailAlready:
            let errorAlert = showErrorAlert(errorMessage: "Registrasi Gagal. Email yang anda daftarkan sudah memiliki akun.")
            self.present(errorAlert, animated: true)
            
        case .passowrdNotSame:
            let errorAlert = showErrorAlert(errorMessage: "Registrasi Gagal. Passowrd tidak sesuai, silahkan lakukan pengecekan kembali.")
            self.present(errorAlert, animated: true)
        }
    }
}

//// MARK: - UITextFieldDelegate
//extension RegisterViewController: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//}
