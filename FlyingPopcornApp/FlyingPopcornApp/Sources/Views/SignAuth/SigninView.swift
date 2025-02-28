//
//  LoginView.swift
//  Sai
//
//  Created by CHYUN on 12/16/24.
//

import UIKit

// 로그인 화면
final class SigninView: UIView {
    weak var delegate: SigninViewDelegate?
    
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let emailTextField = StrokeEmailField(hintText: "이메일")
    private let passwordTextField = StrokePasswordField(hintText: "비밀번호")
    private let signinButton = MainSolidButton(title: "로그인")
    private let withoutSigninButton = UIButton()
    lazy var signSwitchLabel = SignSwitchLabel(
        question: "계정이 없으신가요?",
        buttonTitle: "가입하기",
        buttonEvent: switchToSignup,
        frame: frame
    )
    
    // 입력정보 부족시 띄울 알러트
    var showAlert: ((String, String, (() -> Void)?) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        signinButton.addTarget(self, action: #selector(checkUser), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        [titleLabel, subTitleLabel, emailTextField, passwordTextField, signinButton, withoutSigninButton, signSwitchLabel].forEach { view in
            addSubview(view)
        }
        
        titleLabel.text = "환영합니다!"
        titleLabel.font = .systemFont(ofSize: 30, weight: .bold)
        
        subTitleLabel.text = "로그인을 위해 정보를 입력해주세요."
        subTitleLabel.font = .systemFont(ofSize: 16, weight: .regular)
        subTitleLabel.textColor = .fp300
        
        withoutSigninButton.setTitle("로그인 없이 둘러보기 >", for: .normal)
        withoutSigninButton.setTitleColor(.fpRed, for: .normal)
        withoutSigninButton.titleLabel?.font = .systemFont(ofSize: 14)
        withoutSigninButton.addTarget(self, action: #selector(takeAroundWithout), for: .touchUpInside)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(40)
            make.leading.equalTo(safeAreaLayoutGuide).offset(24)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-24)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(titleLabel)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(32)
            make.leading.trailing.equalTo(titleLabel)
            make.height.equalTo(52)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(16)
            make.leading.trailing.height.equalTo(emailTextField)
        }
        
        signinButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(80)
            make.leading.trailing.height.equalTo(emailTextField)
        }
        
        withoutSigninButton.snp.makeConstraints { make in
            make.top.equalTo(signinButton.snp.bottom)
            make.height.equalTo(emailTextField)
            make.centerX.equalTo(signinButton.snp.centerX)
        }
        
        signSwitchLabel.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-60)
            make.centerX.equalTo(signinButton.snp.centerX)
        }
    
    }
    
    @objc private func checkUser() {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        // 1. 이메일과 비밀번호 값이 비어있는 경우
        if email.isEmpty || password.isEmpty {
            showAlert?("로그인 오류", "모든 항목을 기입해주세요.", nil)
            
        // 2. 유효하지 않은 이메일일 경우
        } else if !emailTextField.isValidEmail(email: email) {
            showAlert?("이메일 오류", "올바른 이메일을 입력해주세요.", nil)
            
        // 3. 이메일과 비밀번호 일치하는지 검사
        } else {
            switch UserDefaultsHelper.shared.checkUserData(email: email, password: password).response {
            // 3-1. 이메일과 비밀번호 일치
            case true:
                // 현재 사용자 이메일 저장 (관리자 계정이 아닐때만)
                if !(email == UserDefaultsHelper.masterEmail) {
                    UserDefaultsHelper.shared.saveCurrentUser(email: email)
                }
                // UserData 업데이트
                UserDefaultsHelper.shared.loadUserData(email: email)
                // 화면 이동
                showAlert?("로그인 성공", "환영합니다!") { [weak self] in
                    self?.delegate?.moveToMain()
                }
            // 3-2. 이메일과 비밀번호 불일치
            case false:
                showAlert?("로그인 오류", "이메일과 비밀번호가 일치하지 않습니다.", nil)
            }
        }
    }
    
    @objc private func takeAroundWithout() {
        delegate?.moveToMain()
    }
    
    @objc private func switchToSignup() {
        delegate?.didTapSignupButton()
    }
}

