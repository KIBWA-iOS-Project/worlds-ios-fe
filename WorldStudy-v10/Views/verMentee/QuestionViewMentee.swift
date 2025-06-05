//
//  QuestionView.swift
//  WorldStudy-v10
//
//  Created by 이서하 on 5/27/25.
//
//  공통 QuestionView에서 역할 별로 분리

import SwiftUI

struct QuestionViewMentee: View {
    //    @Binding var isPresented: Bool
    @State private var showingCreateQuestionSheet = false
    @State private var newQuestionTitle = ""
    @State private var newQuestionContent = ""
    @State private var isCreatingQuestion = false
    @State private var createQuestionError: String?
    @State private var goToMyPageMenteeView = false //화면이동-메인페이지 생성 후 변경
    
    var token: String = ""
    @ObservedObject var viewModel: QBoardViewModel
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 2) {
                
                //화면이동-메인페이지 생성 후 변경
                NavigationLink(destination: MyPageMentee(authViewModel: AuthViewModel()), isActive: $goToMyPageMenteeView) {
                    EmptyView()
                }
                .hidden()
                
                Text("모든 질문 보기")
                    .font(.callout)
                    .foregroundColor(.gray)
                    .fontWeight(.ultraLight)
                    .padding(.leading, 25)
                    .padding(.top, 50)
                
                Text("궁금한 게 있으면")
                    .font(.title3)
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .padding(.leading, 25)
                    .padding(.top, 15)
                
                Text("멘토 친구들에게 물어보세요 🌱")
                    .font(.title3)
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .padding(.leading, 25)
                    .padding(.top, 5)
                
                List(viewModel.questions) { question in
                    NavigationLink(destination: QuestionDetailView(question: question)) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(question.title)
                                .font(.headline)
                            Text(question.content)
                                .font(.subheadline)
                                .lineLimit(2)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
                
                //            .navigationTitle("게시판")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("질문하기") {
                        showingCreateQuestionSheet = true
                    }
                }
            }
            .onAppear {
                Task {
                    await viewModel.fetchQuestions()
                }
            }
            .fullScreenCover(isPresented: $showingCreateQuestionSheet) {
                CreateQuestionView(
                    title: $newQuestionTitle,
                    content: $newQuestionContent,
                    isPresented: $showingCreateQuestionSheet,
                    isCreating: $isCreatingQuestion,
                    errorMessage: $createQuestionError,
                    onSubmit: { _ in isCreatingQuestion = true
                        Task {
                            isCreatingQuestion = true
                            do {
                                let result = try await APIService.shared.createQuestion(
                                    title: newQuestionTitle,
                                    content: newQuestionContent,
                                    image: nil
                                )
                                if result {
                                    await viewModel.fetchQuestions()
                                    newQuestionTitle = ""
                                    newQuestionContent = ""
                                    showingCreateQuestionSheet = false
                                } else {
                                    createQuestionError = "질문 등록 실패"
                                }
                            } catch {
                                createQuestionError = "오류: \(error.localizedDescription)"
                            }
                            isCreatingQuestion = false
                        }
                    }
                )
            }
        }
    }
}

#Preview {
    QuestionViewMentee(viewModel: QBoardViewModel())
    //isPresented: .constant(true), : 프리뷰에서 isPresented를 항상 true로 설정해주는 바인딩
}

