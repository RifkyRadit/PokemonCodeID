//
//  LoginViewController.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 30/07/25.
//

import UIKit
import RealmSwift
import RxSwift
import MBProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var loginContentView: UIView!
    @IBOutlet weak var userNameField: CoreTextField!
    @IBOutlet weak var passwordField: CoreTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerLabel: UILabel!
    
    var fieldsArr: [CoreTextField] = []
    var activeField: UITextField?
    var lastOffset: CGPoint?
    var keyboardHeight: CGFloat?
    
    private(set) var viewModel = LoginViewModel()
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
        userNameField.configureCustomTextField(placeholderText: "Username")
        passwordField.configureCustomTextField(isPassowrdField: true, placeholderText: "Password")
        
        loginButton.layer.cornerRadius = 10
        loginButton.layer.masksToBounds = true
        loginButton.isEnabled = false
        loginButton.backgroundColor = UIColor(named: "color_gray")
        
        setupRegisterText()
        
        [userNameField, passwordField].forEach {
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
        let isFormFilled = !(userNameField.textField.text?.isEmpty ?? true) &&
                           !(passwordField.textField.text?.isEmpty ?? true)
        loginButton.isEnabled = isFormFilled
        loginButton.backgroundColor = isFormFilled ? UIColor(named: "color_main_red") : UIColor(named: "color_gray")
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        let usernameText = userNameField.textField.text ?? ""
        let passwordText = passwordField.textField.text ?? ""
        
        viewModel.inputs.loginUser(username: usernameText, password: passwordText)
    }
}

// MARK: - Configure View
extension LoginViewController {
    private func configureState(state: LoginViewState) {
        switch state {
        case .loading:
            let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
            progressHUD.label.text = "Loading...."
            
        case .loginResult(let resultState):
            MBProgressHUD.hide(for: self.view, animated: true)
            configureLoginValidation(with: resultState)
        }
    }
    
    private func configureLoginValidation(with state: LoginResult) {
        switch state {
        case .successLogin:
            let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
            progressHUD.mode = .customView
            progressHUD.customView = UIImageView(image: UIImage(systemName: "checkmark"))
            progressHUD.label.text = "Berhasil"
            
            progressHUD.hide(animated: true, afterDelay: 0.5)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self else { return }
                self.navigateToRootMainTabbar()
            }
            
        case .userNotFound:
            let errorAlert = showErrorAlert(errorMessage: "Username yang anda masukkan tidak terdaftar, silahkan mendaftar terlebih dahulu.")
            self.present(errorAlert, animated: true)
            
        case .wrongPassword:
            let errorAlert = showErrorAlert(errorMessage: "Password yang anda masukkan salah, silahkan periksa lagi.")
            self.present(errorAlert, animated: true)
        }
    }
    
    private func navigateToRootMainTabbar() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate,
              let window = sceneDelegate.window
        else {
            return
        }
        
        let mainTabbarController = MainTabViewController()
        let navController = UINavigationController(rootViewController: mainTabbarController)
        window.rootViewController = navController
        UIView.transition(with: window,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
    }
}

// MARK: - setup register text
extension LoginViewController {
    private func setupRegisterText() {
        let registerText = "Belum punya akun? Silahkan mendaftar"
        registerLabel.attributedText = getCustomAttributeText(fullText: registerText, rangeText: "mendaftar")
        registerLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLabelTap(_ :)))
        registerLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleLabelTap(_ gesture: UITapGestureRecognizer) {
        guard let label = gesture.view as? UILabel,
              let attributedText = label.attributedText else
        {
            return
        }
        
        if getValidateAreaGestureTapText(gesture: gesture, label: label, attributedText: attributedText, rangeText: "mendaftar") {
            let registerViewController = RegisterViewController()
            self.navigationController?.pushViewController(registerViewController, animated: true)
        }
    }
}
