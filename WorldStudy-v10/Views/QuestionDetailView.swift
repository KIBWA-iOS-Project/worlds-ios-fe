//
//  QuestionDetailView.swift
//  WorldStudy-v10
//
//  Created by 이서하 on 5/23/25.
//
//  댓글 쓰기는 또 다른 뷰에서 => 멘토만 가능하게

import SwiftUI

struct QuestionDetailView: View {
    let question: Question
    @State var answer: [Answer] = []
    @State var attatchmentImage: [Attachment] = []
    
    @State private var goToCreateAnswerView = false
    
    let backgroundColor = Color("BackgroundColor")
    
    var body: some View {
        VStack(spacing:0) {
            VStack(alignment: .leading, spacing: 15) {
                Text(question.title)
                    .font(.title)
                    .bold()
                    .padding(.top, 10)
                
                HStack {
                    Text("작성일: \(question.createdAt)")
//                    Text("작성자: \(question.user?.name)")     // 작성자: (optional)name 으로 출력됨
                    Text("작성자: \(question.user?.name ?? "알 수 없는 사용자")")
                }
                .font(.subheadline)
                .foregroundColor(.gray)
                
                Divider()
                
                
                Text(question.content)
                    .font(.body)
                    .frame(height: 100)
                
//                if let attachments = question.attachments, !attachments.isEmpty {
//                        VStack(alignment: .leading, spacing: 10) {
//                            Text("첨부파일")
//                                .font(.headline)
//                                .padding(.top)
//
//                            ForEach(attachments) { attachment in
//                                if let url = URL(string: attachment.url) {
//                                    Link(destination: url) {
//                                        Text(url.lastPathComponent)
//                                            .underline()
//                                            .foregroundColor(.blue)
//                                    }
//                                }
//                            }
//                        }
//                    }
            }
            .padding()
            
            HStack(spacing: 5) {
                Image("mentorIcon")
                    .resizable()
                    .frame(width: 40, height: 40)

                Text("멘토들의 답변")
                    .font(.title3)
                    .bold()
            }
            .padding(.top, 10)
            
            Divider()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    if answer.isEmpty {
                        Text("아직 답변이 없습니다.")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(answer) { answer in
                            VStack(alignment: .leading, spacing: 8) {
                                Text("\(answer.user.name) 멘토")
                                    .font(.subheadline)
                                    .bold()
                                Text(answer.content)
                                    .font(.body)
                                Divider()
                            }
                        }
                    }
                }
                .padding()
            }
            
            Spacer()
            
            //멘티일땐 "답변은 멘토만 작성 가능합니다" 메시지 띄우기
            Button(action: {
//                if authViewModel.role == "멘티" {
//                    showRoleAlert = true
//                } else {
                goToCreateAnswerView = true
            })
            {
                Text("답변 작성하기")
                    .foregroundColor(.white)
                    .fontWeight(.medium)
                    .padding()
                    .frame(width: 150)
                    .background(Color("darkbrown"))
                    .cornerRadius(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.black, lineWidth: 0))
                
            }
            .padding(.bottom, 20)

//                .alert("답변은 멘토만 작성 가능합니다.", isPresented: $showRoleAlert) {
//                        Button("확인", role: .cancel) { }
//                    }
                .sheet(isPresented: $goToCreateAnswerView) {
                    CreateAnswerView(question: question) { newAnswer in
                        answer.append(newAnswer)
            }
        }
    }
        
        
        
        .padding(.bottom, 20)
        .onAppear {
            Task {
                do {
                    self.answer = try await APIService.shared.fetchAnswers(questionId: question.id)
                } catch {
                    print("답변 로딩 실패: \(error.localizedDescription)")
                }
            }
        }
        .background(backgroundColor.ignoresSafeArea())
    }
}
