//
//  RegisterViewController.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 30/07/25.
//

import UIKit
import RxSwift
import MBProgressHUD

class RegisterViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var usernameField: CoreTextField!
    @IBOutlet weak var emailField: CoreTextField!
    @IBOutlet weak var passwordField: CoreTextField!
    @IBOutlet weak var confirmPasswordField: CoreTextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginLabel: UILabel!
    
    private(set) var viewModel = RegisterViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bindViewModel()
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
        
        setupLoginText()
        
        [usernameField, emailField, passwordField, confirmPasswordField].forEach {
            $0?.textField.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
        }
        
        hideKeyboardWhenTappedArround()
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

// MARK: - setup login text
extension RegisterViewController {
    private func setupLoginText() {
        let loginText = "Sudah punya akun? Silahkan masuk"
        loginLabel.attributedText = getCustomAttributeText(fullText: loginText, rangeText: "masuk")
        loginLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLabelTap(_ :)))
        loginLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleLabelTap(_ gesture: UITapGestureRecognizer) {
        guard let label = gesture.view as? UILabel,
              let attributedText = label.attributedText else
        {
            return
        }
        
        if getValidateAreaGestureTapText(gesture: gesture, label: label, attributedText: attributedText, rangeText: "masuk") {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - State Registration
extension RegisterViewController {
    private func configureState(state: RegisterViewState) {
        switch state {
        case .loading:
            let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
            progressHUD.label.text = "Loading...."
            
        case .successRegistration:
            MBProgressHUD.hide(for: self.view, animated: true)
            let alert = UIAlertController(title: "", message: "Registrasi berhasil. Silahkan untuk masuk kembali", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OKE", style: .default, handler: { [weak self] _ in
                guard let self else {
                    return
                }
                
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true)
        case .failedRegistration:
            MBProgressHUD.hide(for: self.view, animated: true)
            let errorAlert = showErrorAlert(errorMessage: "Registrasi Gagal. Silahkan coba kembali beberapa saat lagi")
            self.present(errorAlert, animated: true)
        case .invalidData(let state):
            MBProgressHUD.hide(for: self.view, animated: true)
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
            
        case .wrongEmailFormat:
            let errorAlert = showErrorAlert(errorMessage: "Registrasi Gagal. Email tidak sesuai, harap perhatikan format email.")
            self.present(errorAlert, animated: true)
        }
    }
}
