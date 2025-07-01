//
//  LoginBotomSheetStore.swift
//  Perqara - Clients
//
//  Created by Ilham Prabawa on 15/05/25.
//

import Foundation
import GnDKit
import AprodhitKit
import AprodhitAuthModule
import Combine

class KemenPPPALoginBottomSheetStore: SheetStore {
  
  private let repository: LoginRepositoryLogic
  private let otpNavigator: OTPNavigator
  private let registerNavigator: RegisterNavigator
  private var onSuccess: (String, EnumOTPAccountState) -> Void
  
  var username = CurrentValueSubject<String, Never>("")
  var usernameError: Bool = false
  var usernameErrorMessage = CurrentValueSubject<String, Never>("")
  var errorColor: Int = 0xFDF6E5
  
  private var validatePhoneNumber: AnyPublisher<Bool, Never> {
    username
      .dropFirst(2)
      .map{
        return ($0.hasPrefix("+62") || $0.hasPrefix("0"))
        && Int($0) != nil
        && ($0.count > 9 && $0.count < 13)
      }
      .eraseToAnyPublisher()
  }
  
  public var validUsername: AnyPublisher<Bool, Never> {
    Publishers.CombineLatest(validateEmail, validatePhoneNumber).map { email, phone in
      return email || phone
    }.eraseToAnyPublisher()
  }
  
  private var validateEmail: AnyPublisher<Bool, Never> {
    username
      .dropFirst(2)
      .map{ $0.isValidEmail() }
      .eraseToAnyPublisher()
  }
  
  init(
    repository: LoginRepositoryLogic,
    otpNavigator: OTPNavigator,
    registerNavigator: RegisterNavigator,
    onSuccess: @escaping (String, EnumOTPAccountState) -> Void
  ) {
    self.repository = repository
    self.otpNavigator = otpNavigator
    self.registerNavigator = registerNavigator
    self.onSuccess = onSuccess
    
    super.init()
    
    observer()
  }
  
  required init() {
    fatalError("init() has not been implemented")
  }
  
  //MARK: - API
  
  @MainActor
  public func requestLogin() async {
    guard !usernameError else { return }
    
    indicateLoading()
    
    do {
      _ = try await repository.requestSignIn(parameters: .init(username: username.value))
      
      indicateSuccess()
      presentOTP()
      
    } catch {
      guard let error = error as? ErrorMessage else { return }
      GLogger(
        .info,
        layer: "Presentation",
        message: "error \(error)"
      )
    }
    
  }
  
  public func presentOTP() {
    onSuccess(username.value, .isLogin)
  }
  
  public func navigateToRegister() {
    registerNavigator.navigateToRegister()
  }
  
  private func observer() {
    validateEmail
      .removeDuplicates()
      .sink { valid in
        if valid {
          self.usernameErrorMessage.send("Kode OTP akan dikirim ke email")
          self.errorColor = 0x209D4E
        }
      }.store(in: &subscriptions)
    
    validatePhoneNumber
      .removeDuplicates()
      .sink { valid in
        if valid {
          self.usernameErrorMessage.send("Kode OTP akan dikirim ke Whatsapp")
          self.errorColor = 0x209D4E
        }
      }.store(in: &subscriptions)
    
    validUsername
      .removeDuplicates()
      .subscribe(on: DispatchQueue.main)
      .sink { [weak self] valid in
        if !valid {
          self?.usernameErrorMessage.send("Format masukkan belum sesuai")
          self?.errorColor = 0xFA4D56
        }
      }.store(in: &subscriptions)
  }
  
}
