
//
//  Untitled.swift
//  HomeFlow
//
//  Created by muhammad yusuf on 20/06/25.
//


import Foundation
import SwiftUI
import UIKit
import GnDKit
import AprodhitKit
import Combine
import AprodhitAuthModule
import FirebaseAnalytics

public class ListAdvocateKemenPPPAViewController: NiblessViewController {

  private let store: ListAdvocateKemenPPPAStore
  private var loginBottomSheetManager: DismissableActionBottomSheetManager!
  private var snackbarManager: SnackbarManager?
  private var showSnackbar = PassthroughSubject<Bool, Never>()
  private var snackbarMessage = CurrentValueSubject<String, Never>("")
  
  lazy var skeletonTableView: SkeletonAdvocateKemenPPPATableView = {
    let sv = SkeletonAdvocateKemenPPPATableView()
    sv.translatesAutoresizingMaskIntoConstraints = false
    sv.backgroundColor = .clear
    return sv
  }()
  
  //Variable
  private var subscriptions = Set<AnyCancellable>()

  public init(
    store: ListAdvocateKemenPPPAStore) {
      self.store = store
      super.init()
    }

  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    navigationController?.setNavigationBarHidden(false, animated: false)
  }

  public override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    navigationController?.setNavigationBarHidden(true, animated: false)
  }

  public override func loadView() {
    super.loadView()

    let rootView = UIHostingController(rootView: ListAdvocateKemenPPPAView(store: store))
    addFullScreen(childViewController: rootView)
  }

  public override func viewDidLoad() {
    super.viewDidLoad()

    standardNavBar(title: "Daftar Advokat")

    view.backgroundColor = UIColor.gray050

    observeStore()
  }
  
  private func observeStore() {
    store.$isPresentSekeleton
      .receive(on: RunLoop.current)
      .subscribe(on: DispatchQueue.main)
      .sink { [weak self] state in
        if state {
          self?.addSkeletonTableView()
        } else {
          self?.removeSkeletonTableView()
        }
      }.store(in: &subscriptions)
    
    store.$showLogin
      .receive(on: DispatchQueue.main)
      .subscribe(on: DispatchQueue.main)
      .sink { [weak self] state in
        if state {
          self?.presentLoginBottomSheet()
        }
      }.store(in: &subscriptions)
    
    store.$showSnakeBarNotification
      .receive(on: DispatchQueue.main)
      .subscribe(on: DispatchQueue.main)
      .sink { [weak self] state in
        if state {
          self?.showSnakeBarNotification()
        }
      }.store(in: &subscriptions)
    
  }
  
  private func addSkeletonTableView() {
    view.addSubview(skeletonTableView)
    NSLayoutConstraint.activate([
      skeletonTableView.topAnchor.constraint(equalTo: view.topAnchor),
      skeletonTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      skeletonTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      skeletonTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }
  
  private func removeSkeletonTableView() {
    if view.subviews.contains(skeletonTableView) {
      skeletonTableView.removeFromSuperview()
    }
  }
  
  func presentLoginBottomSheet() {
    let remote = LoginRemoteDataSource(service: AprodhitKit.NetworkService.sharedInstance)
    let repository = LoginRepository(remote: remote)
    
    let bottomStore = KemenPPPALoginBottomSheetStore(
      repository: repository,
      otpNavigator: store.viewModel,
      registerNavigator: store.viewModel
    ) { [weak self] (username, type) in
      self?.presentOTPViewController(username: username, type: type)
    }
    
    let contentView = KemenPPPALoginBottomSheetView(store: bottomStore)
    
    let controller = KemenPPPALoginBottomSheetViewController()
      .setStore(bottomStore)
      .setContentView(contentView)
      .setUsedFixedHeight(with: 180)
      .setDismissable(true)
    
    loginBottomSheetManager = DismissableActionBottomSheetManager(
      navigationController: navigationController,
      parentController: self
    )
    
    loginBottomSheetManager
      .setController(controller: controller)
      .show()
  }
  
  private func hideLoginBottomSheet() {
    loginBottomSheetManager.releaseBottomSheet()
  }
  
  public func presentOTPViewController(
    username: String,
    type: EnumOTPAccountState
  ) {
    let viewControllerToPresent = OTPViewController(
      storeFactory: self,
      username: username,
      type: .isLogin
    ) { [weak self] in
      self?.hideLoginBottomSheet()
      self?.hideOTPViewController()
      self?.showSnackbar.send(true)
      self?.snackbarMessage.send(NSLocalizedString(AprodhitKit.Constant.Text.LOGGED_IN_SUCCESSFUL, comment: ""))
      self?.showSnakeBarLogin()
    }
    
    viewControllerToPresent.modalPresentationStyle = .fullScreen
    
    navigationController?.present(viewControllerToPresent, animated: true)
  }
  
  public func hideOTPViewController() {
    navigationController?.dismiss(animated: true) {
      
    }
  }
  
  public func showSnakeBarLogin() {
    self.snackbarManager = SnackbarManager()
    self.snackbarManager!
      .setParent(self)
      .setColor(UIColor.success050)
      .setTextColor(UIColor.success500)
      .setMessage(snackbarMessage.value)
      .setShow(showSnackbar)
      .show()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      self.snackbarManager = nil
    }
  }
  
  public func showSnakeBarNotification() {
    showSnackbar(
        message: "Notifikasi berhasil diaktifkan",
        image: "ic_subtract_kemenPPPA"
    )
  }
  
  func showSnackbar(message: String, image: String) {
      let snackbar = KemenPPPASnackbarView(message: message, imageName: image)

      view.addSubview(snackbar)

      NSLayoutConstraint.activate([
          snackbar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
          snackbar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
          snackbar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0)
      ])

      snackbar.alpha = 0
      UIView.animate(withDuration: 0.3) {
          snackbar.alpha = 1
      }

      DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
          UIView.animate(withDuration: 0.3, animations: {
              snackbar.alpha = 0
          }, completion: { _ in
              snackbar.removeFromSuperview()
          })
      }
  }
  
}

extension ListAdvocateKemenPPPAViewController: OTPStoreFactory {
  
  public func makeOTPStore(
    username: String,
    type: EnumOTPAccountState
  ) -> OTPStore {
    
    let remote = OTPRemoteDataSourceImpl(service: store.network)
    let repository = OTPRepositoryImpl(remote: remote)
    
    return OTPStore(
      username: username,
      type: type,
      otpRepository: repository,
      userSessionDataSource: store.userSessionDataSource,
      dashboardResponder: MockNavigator()
    )
  }
  
}
