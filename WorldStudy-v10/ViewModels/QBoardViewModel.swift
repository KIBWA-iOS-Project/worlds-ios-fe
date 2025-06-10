//
//  QBoardViewModel.swift
//  WorldStudy-v10
//
//  Created by 이서하 on 5/26/25.
//

import Foundation
import Combine
import UIKit

class QBoardViewModel: ObservableObject {
    @Published var questions: [Question] = [] // 질문 리스트
    @Published var selectedQuestion: Question? // 질문 하나 선택 (디테일 보기용)
    
    // 질문 전체 목록 불러오기
    func fetchQuestions() async {
        do {
            let questions = try await APIService.shared.fetchQuestions()
            await MainActor.run {
                self.questions = questions
            }
        } catch {
            print("질문 목록 불러오기 실패: \(error)")
        }
    }
    
    // 질문 상세 불러오기
    func fetchQuestionDetail(questionId: Int) async {
        do {
            let question = try await APIService.shared.fethQuestionDetail(questionId: questionId)
            await MainActor.run {
                self.selectedQuestion = question
            }
        } catch {
            print("질문 상세 불러오기 실패: \(error)")
        }
    }
    
    // 질문 등록 (이미지 포함)
    func createQuestion(title: String, content: String, image: UIImage?) async throws {
        let success = try await APIService.shared.createQuestion(title: title, content: content, image: image)
        
        if success {
            await fetchQuestions() // 질문 목록 새로고침
        } else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "질문 등록에 실패했습니다."])
        }
    }
}
