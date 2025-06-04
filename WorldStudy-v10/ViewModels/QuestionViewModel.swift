//
//  QuestionViewModel.swift
//  Login1
//
//  Created by 이다은 on 6/2/25.
//

import Combine
import Foundation

class QuestionViewModel: ObservableObject {
    @Published var questions: [Question] = []
    @Published var errorMessage: String?

    func loadUserQuestions() {
        guard let userId = UserDefaults.standard.value(forKey: "userId") as? Int else {
            self.errorMessage = "유저 정보가 없습니다."
            return
        }

        Task {
            do {
                let userQuestions = try await APIService.shared.fetchUserQuestions(userId: userId)
                await MainActor.run {
                    self.questions = userQuestions
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "질문 불러오기 실패"
                }
            }
        }
    }
}
