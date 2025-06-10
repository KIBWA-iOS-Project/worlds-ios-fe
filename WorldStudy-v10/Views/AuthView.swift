//
//  AuthView.swift
//  Login
//
//  Created by 이다은 on 5/27/25.
//

import SwiftUI

struct AuthView: View {
    let backgroundColor2 = Color("BackgroundColor2")
    @ObservedObject var viewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var name = ""
    @State private var role = ""
    @State private var isSignup = false
    @State private var selectedRole: String? = nil
    
    var body: some View {
        ZStack {
            backgroundColor2.ignoresSafeArea()
            
            VStack(spacing: 200) {
                Spacer().frame(height: 60)
                
                if isSignup {
                    signupSection
                } else {
                    loginSection
                }
                
                Text(isSignup ? (viewModel.signupError ?? "") : (viewModel.loginError ?? ""))
                    .foregroundColor(.red)
                    .opacity((isSignup ? viewModel.signupError : viewModel.loginError) == nil ? 0 : 1)
                    .padding(.top, -150)
            }
            .padding(.horizontal, 30)
        }
    }
    
    var loginSection: some View {
        VStack(spacing: 16) {
            Text("로그인 하기")
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TextField("이메일 주소", text: $email)
                .customAuthField()
            
            SecureField("비밀번호", text: $password)
                .customAuthField()
            
            Button("로그인") {
                Task {
                    await viewModel.login(email: email, password: password)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(red: 0.4627, green: 0.6902, blue: 0.9686))
            .foregroundColor(.white)
            .cornerRadius(10)
            
            Button("회원가입하기") {
                isSignup = true
            }
            .foregroundColor(.gray)
            .font(.footnote)
        }
    }
    
    var signupSection: some View {
        VStack(spacing: 16) {
            Text("회원가입 하기")
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, -80)
            Text("누구의 계정인가요?")
                .font(.system(size: 20))
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundColor(.black)
                .padding(.top, -30)
            
            HStack(spacing: 20) {
                roleCard(role: "멘토", image: "mentorUser", isSelected: selectedRole == "멘토")
                    .onTapGesture { selectedRole = "멘토" }
                
                roleCard(role: "멘티", image: "menteeUser", isSelected: selectedRole == "멘티")
                    .onTapGesture { selectedRole = "멘티" }
            }
            .padding(.bottom, 20)
            Group {
                TextField("이메일을 입력해주세요.", text: $email)
                    .customAuthField()
                SecureField("비밀번호를 입력해주세요.", text: $password)
                    .customAuthField()
                TextField("이름을 입력해주세요.", text: $name)
                    .customAuthField()
            }
            .padding(.bottom)
            
            Button("회원가입") {
                guard let selected = selectedRole else {
                    viewModel.signupError = "역할을 선택해주세요."
                    return
                }
                
                Task {
                    print("회원가입: \(email), \(password), \(name), 역할: \(selected)")
                    await viewModel.signup(email: email, password: password, name: name, role: selected)
                    await MainActor.run {
                        isSignup = false
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(red: 0.4627, green: 0.6902, blue: 0.9686))
            .foregroundColor(.white)
            .cornerRadius(10)
            
            Button("로그인하기") {
                isSignup = false
            }
            .foregroundColor(.gray)
            .font(.footnote)
        }
    }
    
    func roleCard(role: String, image: String, isSelected: Bool) -> some View {
        VStack {
            Image(image)
                .resizable()
                .frame(width: 50, height: 50)
            Text(role)
                .font(.footnote)
                .foregroundColor(isSelected ? Color.blue : Color.black)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3), lineWidth: 2)
                .background(Color.white.cornerRadius(12))
        )
    }
}

extension View {
    func customAuthField() -> some View {
        self
            .padding(.horizontal)
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            .font(.body)
            .autocapitalization(.none)
    }
}

#Preview {
    AuthView(viewModel: AuthViewModel())
}

