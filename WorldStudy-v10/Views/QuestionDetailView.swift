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
//    let answer: [Answer]
    @State var answer: [Answer] = []
    
    @State private var goToCreateAnswerView = false
    
    var body: some View {
        VStack(spacing:0) {
            VStack(alignment: .leading, spacing: 15) {
                Text(question.title)
                    .font(.title)
                    .bold()
                    .padding(.top, 50)
                
                HStack {
                    Text("작성일: \(question.createdAt.formatted())")
                    Text("작성자: \(question.userId)")
                }
                .font(.subheadline)
                .foregroundColor(.gray)
                
                Divider()
                
                Text(question.content)
                    .font(.body)
            }
            .padding()
            
            Divider()
            
            Text("멘토 답변")
                .font(.title3)
                .bold()
                .padding(.top, 10)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    if answer.isEmpty {
                        Text("아직 답변이 없습니다.")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(answer) { answer in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(answer.userId)
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
                goToCreateAnswerView = true
            }) {
                Text("답변 작성하기")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .sheet(isPresented: $goToCreateAnswerView, content: {
                CreateAnswerView { createAnswer in
                    answer.append(createAnswer)
                }
            })
            
//            .sheet(isPresented: $goToCreateAnswerView) {
//                CreateAnswerView (
//                    userId: currentUserId,
//                    onSubmit: { createAnswer in
//                        answeranswerVM.postAnswer(newAnswer, for: question.id)
//            }
        }
        .padding(.bottom, 20)
    }
}

