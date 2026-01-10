//
//  LoginViewController.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/10.
//

import UIKit
import SnapKit

class LoginViewController: BaseViewController {
    
    private let viewModel = HttpViewModel()
    private var countdownTimer: Timer?
    private var remainingSeconds: Int = 60
    private let totalSeconds: Int = 60
    
    lazy var loginView: LoginView = {
        let loginView = LoginView(frame: .zero)
        return loginView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(appHeadView)
        appHeadView.configTitle(with: LanguageManager.localizedString(for: "Log in"))
        appHeadView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
        }
        
        appHeadView.backBlock = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true) {
                self.loginView.phoneFiled.resignFirstResponder()
                self.loginView.codeFiled.resignFirstResponder()
            }
        }
        
        view.addSubview(loginView)
        loginView.snp.makeConstraints { make in
            make.top.equalTo(appHeadView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        loginView.codeBlock = { [weak self] type in
            guard let self = self else { return }
            self.sendVerificationCode(with: type)
        }
        
        loginView.loginBlock = { [weak self] in
            guard let self = self else { return }
            self.loginView.phoneFiled.resignFirstResponder()
            self.loginView.codeFiled.resignFirstResponder()
            let phoneNumber = self.loginView.phoneFiled.text ?? ""
            let codeNumber = self.loginView.codeFiled.text ?? ""
            guard self.validateInput(phone: phoneNumber, code: codeNumber) else {
                return
            }
            if self.loginView.cycleBtn.isSelected == false {
                ToastManager.showMessage(LanguageManager.localizedString(for: "Please read and agree to the Privacy Policy"))
                return
            }
            Task {
                await self.loginInfo(with: phoneNumber, code: codeNumber)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopCountdown()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loginView.phoneFiled.becomeFirstResponder()
    }
    
    private func sendVerificationCode(with type: String) {
        let phoneNumber = self.loginView.phoneFiled.text ?? ""
        if phoneNumber.isEmpty {
            ToastManager.showMessage(LanguageManager.localizedString(for: "Enter mobile number"))
            return
        }
        requestVerificationCode(phoneNumber: phoneNumber, type: type)
    }
    
    private func validateInput(phone: String, code: String) -> Bool {
        if phone.isEmpty {
            ToastManager.showMessage(LanguageManager.localizedString(for: "Enter mobile number"))
            return false
        }
        
        if code.isEmpty {
            ToastManager.showMessage(LanguageManager.localizedString(for: "Verification Code"))
            return false
        }
        
        return true
    }
    
    private func requestVerificationCode(phoneNumber: String, type: String) {
        Task {
            await self.getCodeInfo(with: type, phone: phoneNumber)
        }
    }
    
    private func startCountdown() {
        stopCountdown()
        remainingSeconds = totalSeconds
        updateCodeButtonState()
        countdownTimer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(updateCountdown),
            userInfo: nil,
            repeats: true
        )
        RunLoop.main.add(countdownTimer!, forMode: .common)
    }
    
    @objc private func updateCountdown() {
        remainingSeconds -= 1
        if remainingSeconds <= 0 {
            stopCountdown()
        }
        updateCodeButtonState()
    }
    
    private func updateCodeButtonState() {
        if remainingSeconds > 0 {
            let title = "\(remainingSeconds)s"
            loginView.codeBtn.isEnabled = false
            loginView.codeBtn.setTitle(title, for: .normal)
        } else {
            let title = LanguageManager.localizedString(for: "Get Code")
            loginView.codeBtn.isEnabled = true
            loginView.codeBtn.setTitle(title, for: .normal)
        }
    }
    
    private func stopCountdown() {
        countdownTimer?.invalidate()
        countdownTimer = nil
        remainingSeconds = 0
    }
    
    @MainActor
    deinit {
        stopCountdown()
    }
}

extension LoginViewController {
    
    private func getCodeInfo(with type: String, phone: String) async {
        do {
            let parameters = ["purported": phone]
            let model = try await type == "voice" ? viewModel.voiceCodeApi(parameters: parameters) : viewModel.codeApi(parameters: parameters)
            if model.illness == 0 {
                if type == "normal" {
                    self.startCountdown()
                }
                self.loginView.codeFiled.becomeFirstResponder()
            }
            ToastManager.showMessage(model.mental ?? "")
        } catch  {
            
        }
    }
    
    private func loginInfo(with phone: String, code: String) async {
        do {
            let parameters = ["migraines": phone, "explanation": code]
            let model = try await viewModel.loginApi(parameters: parameters)
            if model.illness == 0 {
                let phone = model.potions?.migraines ?? ""
                let token = model.potions?.increased ?? ""
                UserDataManager.saveUserData(phone: phone, token: token)
                self.changeRootVc()
            }
            ToastManager.showMessage(model.mental ?? "")
        } catch  {
            
        }
    }
    
}
