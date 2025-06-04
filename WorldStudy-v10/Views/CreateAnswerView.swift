//
//  CreateAnswerView.swift
//  WorldStudy-v10
//
//  Created by 이서하 on 5/27/25.
// 질문디테일뷰 (역할 별로 나눠서)-> 멘토한테만 답변하기 버튼나오게 -> 질문답변추가버튼 누르면 -> 해당질문 불러오고 + 답변 칸 만들고 -> 등록완료??

import SwiftUI

//struct CreateAnswerView: View {
//    var onSubmit: (Answer) -> Void
//    
//    @Environment(\.presentationMode) var presentationMode
//    
//    // 예시용 상태
//    @State private var answerContent = ""
//    
//    var body: some View {
//        VStack {
//            TextField("답변 입력", text: $answerContent)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding()
//            
//            Button("등록") {
//
//                let newAnswer = Answer(
//                    id: Int.random(in: 1...1000),
//                    content: createAnswerContent,
//                    userId: "멘토아이디",
//                    questionId: question.createdAt
//                    createdAt: Date(),
//                    deletedAt: nil
//                    )
//                onSubmit(newAnswer)
//                presentationMode.wrappedValue.dismiss()
//            }
//            .padding()
//        }
//    }
//}
