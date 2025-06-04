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
    @State var name: String = "이멘토"
    @State var email: String = "123@naver.com"
    @State private var showAlert = false
    @State private var showPasswordAlert = false
    @State private var newPassword: String = ""
    let recentPosts: [Question] = [
        Question(
            id: 1,
            title: "처음 쓴 글",
            content: "내용1",
            createdAt: Date(),
            deletedAt: nil,
            userId: 1,
            role: "멘티",
            answers: [
                Answer(
                    id: 1,
                    content: "답변1",
                    userId: "2",
                    questionId: 1,
                    createdAt: Date(),
                    deletedAt: nil
                )
                    ]),
    ]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 2) {
                Text("멘토")
                    .font(.callout)
                    .foregroundColor(.gray)
                    .fontWeight(.ultraLight)
                    .padding(.leading, 20)
                    .padding(.top, 50)
                
                
                Text("\(name) 님의 마이페이지")
                    .font(.title)
                    .foregroundColor(.black)
                    .fontWeight(.bold)
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
                                .foregroundColor(.gray)
                                .font(.title3)
                        }
                    }.listRowBackground(Color.blue.opacity(0.2))
                    Section(header: Text("내 정보")) {
                        HStack {
                            Text("이메일")
                            Spacer()
                            Text("\(email)")
                                .foregroundColor(.gray)
                        }
                        HStack {
                            Text("이름")
                            Spacer()
                            Text("\(name)")
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
                            
//                            .alert("비밀번호 변경", isPresented: $showAlert) {
//                                Button("OK", action:{})
//                            } message: {
//                                Text("새로운 비밀번호를 입력해주세요.")
//                                //비밀번호 재설정 : UIkit(alert+텍스트필드) 추가 해야함
//                            }
                        }
                    }
                    //섹션 안에서만 스크롤 되게 수정해야함
                    Section(header: Text("내가 도와준 질문")) {
                        ForEach(recentPosts) { post in
                            NavigationLink(destination: QuestionDetailView(question: post)) {
                                Text(post.title)
                                
                            }
                        }
                    }
                }
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
    }
}


    
#Preview {
    MyPageMentor()
}

// .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
