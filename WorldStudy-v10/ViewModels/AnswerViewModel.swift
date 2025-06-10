//
//  AnswerViewModel.swift
//  WorldStudy-v10
//
//  Created by 이서하 on 6/5/25.
//

import Foundation

class AnswerViewModel {
    @Published var answer: [Answer] = []
    
    //답변 목록
    func fetchAnswers(questionId: Int) async {
        do {
            let answer = try await APIService.shared.fetchAnswers(questionId: questionId)
            await MainActor.run {
                self.answer = answer
            }
        } catch {
            print("댓글 목록 불러오기 실패: \(error)")
        }
    }
    
    //답변 등록
    func createAnswer(questionId: Int, content: String) async throws {
        let success = try await APIService.shared.createAnswer(questionId: questionId, content: content)
        
        for answer in answer {
            print(answer.content)
        }
        
        await fetchAnswers(questionId: questionId)
    }
}
