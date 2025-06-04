//
//  MenteeView.swift
//  World Study1
//
//  Created by 이다은 on 5/26/25.
//

import SwiftUI

struct MenteeView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @StateObject private var questionViewModel = QuestionViewModel()
    
    let backgroundColor = Color("BackgroundColor")
    
    var body: some View {
        let name = authViewModel.name ?? "사용자"
        let role = authViewModel.role ?? "멘티"
        
        NavigationView {
            ZStack{
                Color(backgroundColor).ignoresSafeArea()
                
                VStack {
                    Text("\(role)")
                        .padding(.top, 150)
                        .padding(.leading, -175)
                        .foregroundStyle(.gray)
                    HStack {
                        Text("안녕하세요. \(name) 님")
                            .font(.system(size: 30))
                            .fontWeight(.heavy)
                            .padding(.leading, 20)
                        Image("together")
                            .padding(.leading, -10)
                    }
                    .padding(.top, -40)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("학습 흔적")
                            .font(.system(size: 25))
                            .fontWeight(.bold)
                            .padding(.bottom, 20)
                            .frame(maxWidth: .infinity, alignment: .center) // 중앙 정렬
                        
                        if let error = questionViewModel.errorMessage {
                            Text("질문을 불러올 수 없습니다.")
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity, alignment: .center)
                        } else if questionViewModel.questions.isEmpty {
                            Text("최근 질문이 없습니다.")
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .center)
                        } else {
                            ForEach(questionViewModel.questions.prefix(3)) { question in
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "pawprint.fill")
                                        .foregroundColor(.black)
                                    Text(question.title)
                                        .font(.body)
                                        .foregroundColor(.black)
                                }
                                Divider()
                            }
                        }
                    }
                    .padding()
                    .frame(width: 350, height: 250)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.main, lineWidth: 3)
                            .background(RoundedRectangle(cornerRadius: 16).fill(Color.white))
                    )
                    .padding(.top, -30)
                    
                    NavigationLink(destination: HelpAi()) { // 화면이동
                        HStack {
                            Image("helpai")
                                .resizable()
                                .frame(width: 40, height: 40)
                            Spacer()
                                .overlay(
                                    Text("숙제 도우미 Ai")
                                        .bold()
                                        .foregroundStyle(.white)
                                        .font(.system(size: 25))
                                )
                        }
                        .padding()
                        .frame(width: 350, height: 80)
                        .background(.black)
                        .cornerRadius(10)
                        .padding(.top, 30)
                        .padding(.bottom)
                    }
                    
                    NavigationLink(destination: HelpAi()) { // 화면이동 수정!!
                        HStack {
                            Image("mentor")
                                .resizable()
                                .frame(width: 40, height: 40)
                            Spacer()
                                .overlay(
                                    Text("멘토들에게 질문하기")
                                        .bold()
                                        .foregroundStyle(.white)
                                        .font(.system(size: 25))
                                )
                        }
                        .padding()
                        .frame(width: 350, height: 80)
                        .background(.black)
                        .cornerRadius(10)
                    }
                }
                .padding(.bottom, 100)
            }
        }
        .onAppear {
            questionViewModel.loadUserQuestions()
        }
    }
}

#Preview {
    MenteeView(authViewModel: AuthViewModel())
}
