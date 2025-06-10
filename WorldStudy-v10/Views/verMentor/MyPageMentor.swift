//
//  MyPageMentor.swift
//  WorldStudy-v10
//
//  Created by 이서하 on 5/23/25.
//

import SwiftUI

struct MyPageMentor: View {
    @State var rank: Int = 0
    @State var answer_count: Int = 0
    
    @State private var showAlert = false
    @State private var showPasswordAlert = false
    @State private var newPassword: String = ""
    
    @StateObject private var rankingViewModel = RankingViewModel()
    @ObservedObject var authViewModel: AuthViewModel
    
    let recentPosts: [Question] = []
    @State private var myAnswers: [Answer] = []
    
    var body: some View {
        let name = authViewModel.name ?? "사용자"
        let email = authViewModel.email ?? "이메일 없음"
        
        NavigationView {
            VStack(alignment: .leading, spacing: 2) {
                Text("멘토")
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
                    
                    Image("mentorIcon")
                        .resizable()
                        .frame(width: 50, height: 50)
                    
                }
                .padding(.leading, 20)
                .padding(.vertical, 15)
                
                
                List {
                    Section(header: Text("나의 랭킹")
                        .fontWeight(.bold)){
                            HStack {
                                Text("\(rank)위")
                                    .font(.title2)
                                    .padding(.vertical,10)
                                Spacer()
                                Text("답변 수 \(answer_count)개")
                                    .foregroundColor(.white)
                                    .font(.title3)
                            }
                        }.listRowBackground(Color.brown.opacity(0.9))
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
                            }
                        }
                    }.listRowBackground(Color.gray.opacity(0.2))
                    
                    //섹션 안에서만 스크롤 되게 수정해야함
                    Section(header: Text("내가 도와준 질문")) {
                        ForEach(myAnswers, id: \.id) { answer in
                            if let question = answer.question {
                                NavigationLink(destination: QuestionDetailView(question: question)) {
                                    VStack(alignment: .leading) {
                                        Text(question.title)
                                            .font(.body)
                                        Text("내 답변: \(answer.content)")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
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
        //랭킹 보여주기
        .onAppear {
            rankingViewModel.loadRankings()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if let index = rankingViewModel.rankings.firstIndex(where: { $0.name == name }) {
                    rank = index + 1
                    answer_count = rankingViewModel.rankings[index].count
                }
            }
            Task {
                do {
                    self.myAnswers = try await APIService.shared.fetchMyAnswers()
                } catch {
                    print("내 답변 불러오기 실패: \(error)")
                }
            }
        }
        
    }
}



#Preview {
    MyPageMentor(authViewModel: AuthViewModel())
}

// .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
