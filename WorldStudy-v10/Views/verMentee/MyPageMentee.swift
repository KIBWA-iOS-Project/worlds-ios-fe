//
//  MyPageMentee.swift
//  WorldStudy-v10
//
//  Created by 이서하 on 5/23/25.
//

import SwiftUI

struct MyPageMentee: View {
    @State private var showAlert = false
    @State private var showPasswordAlert = false
    @State private var newPassword: String = ""
    
    @ObservedObject var authViewModel: AuthViewModel
    
    let recentPosts: [Question] = []
    @State private var myQuestions: [Question] = []
    
    var body: some View {
        let name = authViewModel.name ?? "사용자"
        let email = authViewModel.email ?? "이메일 없음"
        
        NavigationView {
            VStack(alignment: .leading, spacing: 2) {
                Text("멘티")
                    .font(.callout)
                    .foregroundColor(.gray)
                    .fontWeight(.light)
                    .padding(.leading, 20)
                    .padding(.top, 50)
                
                
                HStack {
                    
                    Text("\(name) 님의 마이페이지")
                        .font(.title)
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                    
                    Image("icon")
                        .resizable()
                        .frame(width: 50, height: 50)
                    
                }
                .padding(.leading, 20)
                .padding(.vertical, 15)
                
                
                
                List {
                    Section(header: Text("내 정보")) {
                        HStack {
                            Text("이메일")
                            Spacer()
                            Text(email)
                                .foregroundColor(.gray)
                        }
                        HStack {
                            Text("이름")
                            Spacer()
                            Text(name)
                                .foregroundColor(.gray)
                        }
                        HStack {
                            Text("비밀번호")
                            Spacer()
                            Button(action: {
                                showPasswordAlert = true
                            }) {
                                Text("재설정")
                                    .foregroundColor(.blue)
                            }.listRowBackground(Color.gray.opacity(0.2))
                        }
                    }
                    .listRowBackground(Color.gray.opacity(0.2))
                    
                    //섹션 안에서만 스크롤 되게 수정해야함
                    Section(header: Text("나의 질문")) {
                        ForEach(myQuestions) { post in
                            NavigationLink(destination: QuestionDetailView(question: post)) {
                                Text(post.title)
                                
                            }
                        }
                    }
                    .listRowBackground(Color.gray.opacity(0.2))
                }
                .scrollContentBackground(.hidden)
                .listRowBackground(Color.white)
                
                TextFieldWrapper(
                    isPresented: $showPasswordAlert,
                    alert: TextFieldAlert(
                        title: "비밀번호 변경",
                        message: "새 비밀번호를 입력하세요.",
                        placeholder: "4자리 이상 입력하세요.",
                        action: { input in
                            if let input = input {
                                newPassword = input
                                print("입력된 새 비밀번호: \(newPassword)")
                                // 백앤드 이후
                            }
                        }
                    )
                ).frame(width: 0, height: 0)
            }
        }
        .onAppear{
            Task {
                do {
                    self.myQuestions = try await APIService.shared.fetchMyQuestions()
                } catch {
                    print("내 질문 불러오기 실패: \(error)")
                }
            }
        }
    }
}


#Preview {
    MyPageMentee(authViewModel: AuthViewModel())
}


