//
//  CreateAnswerView.swift
//  WorldStudy-v10
//
//  Created by 이서하 on 5/27/25.
//

import SwiftUI

struct CreateAnswerView: View {
    let question: Question
    var onSubmit: (Answer) -> Void
    
    @Environment(\.dismiss) var dismiss
    
    @State private var content: String = ""
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                Group {
                    Text("질문 내용")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text(question.content)
                        .font(.body)
                }
                
                Text("답변 하기")
                    .font(.title3)
                    .bold()
                
                TextEditor(text: $content)
                    .frame(height: 150)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("darkbrown"), lineWidth: 2)
                    )
                    .cornerRadius(10)
                
                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                }
                
                Spacer()
                
                HStack {
                    Spacer()
                    Button(action: {
                        Task {
                            do {
                                let newAnswer = try await APIService.shared.createAnswer(
                                    questionId: question.id,
                                    content: content
                                )
                                onSubmit(newAnswer)
                                dismiss()
                            } catch {
                                errorMessage = "답변은 멘토만 작성 가능합니다"
                            }
                        }
                    }) {
                        Text("작성 완료")
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
                    .disabled(content.trimmingCharacters(in: .whitespaces).isEmpty)
                    Spacer()
                }
            }
            .padding()
            
            
            
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .principal) {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 18)
                }
            }
        }
    }
}
