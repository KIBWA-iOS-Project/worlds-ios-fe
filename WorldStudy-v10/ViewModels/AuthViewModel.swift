//
//  AuthViewModel.swift
//  Login
//
//  Created by 이다은 on 5/27/25.
//

import Foundation
import Combine

class AuthViewModel: ObservableObject {
    @Published var token: String?
    @Published var name: String? = nil
    @Published var isLoggedIn = false
    @Published var loginError: String?
    @Published var signupError: String?
    @Published var role: String?

    private let tokenKey = "jwt_token"

    init() {
        // 앱 실행 시 저장된 값 불러오기
        if let savedToken = UserDefaults.standard.string(forKey: tokenKey) {
            self.token = savedToken
            self.isLoggedIn = true
            self.role = UserDefaults.standard.string(forKey: "role")
            self.name = UserDefaults.standard.string(forKey: "name")
        }
    }

    // 로그인 요청
    func login(email: String, password: String) async {
        Task {
            do {
                print("viewModel login : \(email) \(password)")
                if let result = try await APIService.shared.login(email: email, password: password) {
                    await MainActor.run {
                        print(result.token)
                        self.token = result.token
                        self.role = result.role
                        self.name = result.name
                        self.isLoggedIn = true
                        UserDefaults.standard.set(result.token, forKey: self.tokenKey)
                        UserDefaults.standard.set(result.role, forKey: "role")
                        UserDefaults.standard.set(result.name, forKey: "name")
                        UserDefaults.standard.set(result.userId, forKey: "userId")
                    }
                } else {
                    await MainActor.run {
                        self.loginError = "로그인 실패"
                    }
                }
            } catch {
                await MainActor.run {
                    self.loginError = "로그인 실패"
                }
            }
        }
    }

    // 회원가입 요청
    func signup(email: String, password: String, name: String, role: String) async {
        Task {
            do {
                let success = try await APIService.shared.signup(email: email, password: password, name: name, role: role)
                print("viewModel signup : \(success)")
                if success {
                    await MainActor.run {
                        self.role = role
                        UserDefaults.standard.set(role, forKey: "role")
                    }
                } else {
                    await MainActor.run {
                        self.signupError = "회원가입 실패"
                    }
                }
            } catch {
                await MainActor.run {
                    self.signupError = "회원가입 실패"
                }
            }
        }
    }

    // 로그아웃 처리
    func logout() {
        self.token = nil
        self.isLoggedIn = false
        self.name = nil
        self.role = nil
        UserDefaults.standard.removeObject(forKey: tokenKey)
        UserDefaults.standard.removeObject(forKey: "role")
        UserDefaults.standard.removeObject(forKey: "name")
        UserDefaults.standard.removeObject(forKey: "userId")
    }
}
