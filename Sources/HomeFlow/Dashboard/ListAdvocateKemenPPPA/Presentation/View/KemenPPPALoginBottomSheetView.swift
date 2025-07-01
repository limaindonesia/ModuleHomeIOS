//
//  LoginBottomSheetView.swift
//  Perqara - Clients
//
//  Created by Ilham Prabawa on 15/05/25.
//

import Foundation
import UIKit
import AprodhitKit
import GnDKit

class KemenPPPALoginBottomSheetView: BottomSheetContentView {
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "Masuk Akun Perqara"
    label.font = UIFont.lexendFont(style: .title(size: 20))
    label.numberOfLines = 1
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let usernameTitleLabel: UILabel = {
    let label = UILabel()
    label.text = "Nomor Ponsel atau Email"
    label.font = UIFont.lexendFont(style: .caption(size: 12))
    label.textColor = .darkTextColor
    label.numberOfLines = 1
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let usernameField: UITextField = {
    let textField = UITextField()
    textField.backgroundColor = UIColor.gray050
    textField.placeholder = "contoh@email.com / 0812345678"
    textField.borderStyle = .roundedRect
    textField.layer.cornerRadius = 8
    textField.layer.borderWidth = 1
    textField.layer.borderColor = UIColor.gray200.cgColor
    textField.layer.masksToBounds = true
    textField.translatesAutoresizingMaskIntoConstraints = false
    return textField
  }()
  
  private let errorLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.lexendFont(style: .caption(size: 12))
    label.numberOfLines = 1
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let loginButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Masuk", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.backgroundColor = UIColor.buttonActiveColor
    button.titleLabel?.font = UIFont.lexendFont(style: .title(size: 16))
    button.layer.cornerRadius = 8
    button.heightAnchor.constraint(equalToConstant: 48).isActive = true
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  private let registerLabel: UILabel = {
    let label = UILabel()
    label.text = "Belum punya akun Perqara?"
    label.font = UIFont.systemFont(ofSize: 16)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let registerButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Daftar disini", for: .normal)
    button.setTitleColor(.buttonActiveColor, for: .normal)
    button.titleLabel?.font = UIFont.lexendFont(style: .caption(size: 16))
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  private lazy var registerView: UIView = {
    let view = createRegisterView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  override func setup() {
    super.setup()
    
    setupView()
    observeStore()
  }
  
  override func setupView() {
    super.setupView()
    
    backgroundColor = .white
    layer.cornerRadius = 16
    clipsToBounds = true
    
    addSubview(titleLabel)
    addSubview(usernameTitleLabel)
    addSubview(usernameField)
    addSubview(errorLabel)
    addSubview(loginButton)
    addSubview(registerView)
    
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 48),
      titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      
      usernameTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
      usernameTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      
      usernameField.topAnchor.constraint(equalTo: usernameTitleLabel.bottomAnchor, constant: 8),
      usernameField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      usernameField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      usernameField.heightAnchor.constraint(equalToConstant: 44),
      
      errorLabel.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 4),
      errorLabel.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor),
      errorLabel.trailingAnchor.constraint(equalTo: usernameField.trailingAnchor),
      
      loginButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 16),
      loginButton.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor),
      loginButton.trailingAnchor.constraint(equalTo: usernameField.trailingAnchor),
      loginButton.heightAnchor.constraint(equalToConstant: 48),
      
      registerView.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
      registerView.centerXAnchor.constraint(equalTo: centerXAnchor)
    ])
    
    loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
    registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
  }
  
  private func createRegisterView() -> UIView {
    let hStack = UIStackView(arrangedSubviews: [registerLabel, registerButton])
    hStack.axis = .horizontal
    hStack.spacing = 8
    hStack.alignment = .center
    return hStack
  }
  
  private func observeStore() {
    guard let store = store as? KemenPPPALoginBottomSheetStore else { return }
    
    usernameField.textPublisher
      .receive(on: DispatchQueue.main)
      .subscribe(on: DispatchQueue.main)
      .sink { value in
        store.username.send(value ?? "")
      }.store(in: &subscriptions)
    
    store.usernameErrorMessage
      .receive(on: DispatchQueue.main)
      .subscribe(on: DispatchQueue.main)
      .sink { [weak self] value in
        self?.errorLabel.text = value
        self?.errorLabel.textColor = UIColor(store.errorColor)
      }.store(in: &subscriptions)
    
  }
  
  @objc private func loginTapped() {
    guard let store = store as? KemenPPPALoginBottomSheetStore else { return }
    Task {
      await store.requestLogin()
    }
  }
  
  @objc private func registerTapped() {
    guard let store = store as? KemenPPPALoginBottomSheetStore else { return }
    store.navigateToRegister()
  }
  
}
