//
//  ContentView.swift
//  WorldStudy-v10
//
//  Created by 이서하 on 5/23/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var authViewModel = AuthViewModel()

    var body: some View {
        Group {
            if authViewModel.isLoggedIn {
                if authViewModel.role == "멘토" {
                    TabView{
                        MentorView(authViewModel: authViewModel)
                            .tabItem {
                                Image(systemName: "globe.asia.australia.fill")
                                Text("홈")
                            }
                        Text("커뮤니티")
                            .tabItem {
                                Image(systemName: "bubble.left.and.bubble.right.fill")
                                Text("커뮤니티")
                            }
                        MyPageMentor()
                            .tabItem {
                                Image(systemName: "person.crop.circle")
                                Text("마이페이지")
                            }
                    }
                } else {
                    TabView{
                        MenteeView(authViewModel: authViewModel)
                            .tabItem {
                                Image(systemName: "globe.asia.australia.fill")
                                Text("홈")
                            }
                        Text("커뮤니티")
                            .tabItem {
                                Image(systemName: "bubble.left.and.bubble.right.fill")
                                Text("커뮤니티")
                            }
                        MyPageMentee()
                            .tabItem {
                                Image(systemName: "person.crop.circle")
                                Text("마이페이지")
                            }
                    }
                }
            } else {
                AuthView(viewModel: authViewModel) // 로그인/회원가입 화면
            }
        }
    }
}

#Preview {
    AuthView(viewModel: AuthViewModel())
}
